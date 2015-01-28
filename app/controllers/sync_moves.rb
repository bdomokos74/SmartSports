module SyncMoves

  def sync_moves
    movesconn = Connection.where(user_id: current_user.id, name: 'moves').first
    if movesconn != nil
      sess = JSON.parse(movesconn.data)
    else
      auth = request.env['omniauth.auth']
      current_user.connection.create(name: 'moves', data: auth['credentials']['token'], user_id: current_user.id )
      current_user.save(validate: false)
      sess = { "access_token" => auth['credentials']['token']}
    end
    status = do_sync_moves(sess)
    respond_to do |format|
      format.json { render json: {:status => status}}
    end
  end


  def sync_moves_act_daily
    movesconn = Connection.where(user_id: current_user.id, name: 'moves').first
    if movesconn != nil
      sess = JSON.parse(movesconn.data)

      @moves = Moves::Client.new(sess["token"])
      today = Date.today()
      dateFormat = "%Y-%m-%d"
      todayYmd = today.strftime(dateFormat)
      daily = @moves.daily_activities(todayYmd)
      status = "OK"
    else
      status = "NOK"
    end
    respond_to do |format|
      format.json { render json: {:status => status, :data => daily}}
    end
  end

  private
  def do_sync_moves(sess)
    dateFormat = "%Y-%m-%d"
    @moves = Moves::Client.new(sess["token"])
    @profile = @moves.profile['profile']
    currDate = Date.parse(@profile['firstDate'])
    today = Date.today()
    todayYmd = today.strftime(dateFormat)
    while currDate <= today
      dbActivities = Summary.where("user_id= #{current_user.id} and source = 'moves' and (date between '#{currDate} 00:00:00' and '#{currDate} 23:59:59' )")
      if !dbActivities.all? { |a| a.sync_final }
        dbActivities.each { |a| a.destroy }
        dbActivities = nil
      end
      if dbActivities.nil? or dbActivities.size == 0
        logger.info "syncing #{currDate}"
        currDateYmd = currDate.strftime(dateFormat)
        summary = @moves.daily_summary(currDateYmd)
        for item in summary do
          if item['summary']
            lastUpdate = item['lastUpdate']
            sItem = item['summary']
            isFinal = false
            logger.info "currdate="+currDate.to_s
            logger.info "today="+today.to_s
            if currDate < today
              isFinal = true
            end
            i = 0
            for rec in sItem do
              act = Summary.new( user_id: current_user.id, source: 'moves', date: currDate, activity:  rec['activity'], group: rec['group'],
                  total_duration: rec['duration'],
                  distance: rec['distance'],
                  steps: rec['steps'].to_i,
                  calories: rec['calories'],
                  synced_at: DateTime.now(),
                  sync_final: isFinal
              )
              act.save!
              i = i + 1
            end
          else
            logger.info "no activities for #{currDate}"
          end
        end
      end

      currDate = currDate+1.day
    end
    return "OK"
  end
end