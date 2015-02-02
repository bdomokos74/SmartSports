module SyncFitbit
  def sync_fitbit
    dateFormat = "%Y-%m-%d"
    fitbit_conn = Connection.where(user_id: current_user.id, name: 'fitbit').first
    if fitbit_conn
      connection_data = JSON.parse(fitbit_conn.data)
      client = Fitgem::Client.new(:token => connection_data['token'], :secret => connection_data['secret'], :consumer_key => APP_CONFIG['FITBIT_KEY'], :consumer_secret => APP_CONFIG['FITBIT_SECRET'])
      userinfo = client.user_info
      member_since = userinfo['user']['memberSince']

      now = DateTime.now()
      saved = []
      last_synced = get_last_synced_final_date(current_user.id, "fitbit")
      if !last_synced
        currdate = Date.parse(member_since)
      else
        currdate = last_synced+1.day
      end
      while currdate <= now
        act = client.activities_on_date(currdate)
        remove_activities_on_date(current_user.id, "fitbit", currdate.strftime(dateFormat))
        if save_fitbit_act(act, currdate)
          saved.push(act)
        end
        currdate = currdate+1.day
      end

      result = { :status => "OK", :act => saved}
    else
      result = { :status => "ERR"}
    end
    respond_to do |format|
      format.json { render json: result}
    end
  end

  private

  def save_fitbit_act(rec, date)

    summary = rec['summary']
    lightly = summary['lightlyActiveMinutes']
    very = summary['veryActiveMinutes']
    fairly = summary['fairlyActiveMinutes']
    total = lightly+very+fairly
    distance_total = summary['distances'].select { |it| it['activity']=='total'}
    distance_total = distance_total[0]['distance']
    if distance_total >0.0 and summary['steps']>0
      isFinal = false
      if date < Date.today()
        isFinal = true
      end
      new_act =  Summary.new( user_id: current_user.id, source: 'fitbit', date: date,
          total_duration: total,
          soft_duration: lightly,
          moderate_duration: fairly,
          hard_duration: very,
          distance: distance_total,
          steps: summary['steps'],
          calories: summary['activityCalories'],
          elevation: summary['elevation'],
          synced_at: DateTime.now(),
          sync_final: isFinal
      )
      new_act.save!
      return true
    else
      return false
    end
  end
end