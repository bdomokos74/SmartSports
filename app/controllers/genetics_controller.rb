class GeneticsController < ApplicationController

  # GET /users/:id/genetics
  # GET /users/:id/genetics
  def index
    user_id = params[:user_id]
    source = params[:source]

    order = params[:order]
    limit = params[:limit]

    @personal_records = PersonalRecord.where("user_id = #{user_id}")
    if source
      @personal_records = @personal_records.where("source = '#{source}'")
    end
    if order and order=="desc"
      @personal_records = @personal_records.order(created_at: :desc)
    else
      @personal_records = @personal_records.order(created_at: :asc)
    end
    if limit and limit.to_i>0
      @personal_records = @personal_records.limit(limit)
    end

    @family_records = FamilyRecord.where("user_id = #{user_id}")
    if source
      @family_records = @family_records.where("source = '#{source}'")
    end
    if order and order=="desc"
      @family_records = @family_records.order(created_at: :desc)
    else
      @family_records = @family_records.order(created_at: :asc)
    end
    if limit and limit.to_i>0
      @family_records = @family_records.limit(limit)
    end
    @genetics_records = @personal_records + @family_records

    respond_to do |format|
      format.html
      format.json {render json: @genetics_records }
      format.js
    end
  end

end
