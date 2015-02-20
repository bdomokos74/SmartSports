class PasswordResetsController < ApplicationController
  skip_before_filter :require_login
  layout :resolve_layout

  def create
    @user = User.find_by_email(params[:email])
    logger.info "delivering password reset instructions to "+params[:email]
    begin
      @user.deliver_reset_password_instructions! if @user
      redirect_to(root_path, :notice => 'Instructions have been sent to your email.')
    rescue => e
      logger.info "Exception"
      logger.error e
      logger.error e.backtrace.join("\n")
      redirect_to(root_path, :notice => 'Failed to send email.')
    end

  end

  def edit

    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
    if @user.blank?
      not_authenticated
      return
    end
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end

    # the next line makes the password confirmation validation work
    @user.password_confirmation = params[:user][:password_confirmation]
    # the next line clears the temporary token and updates the password
    if @user.change_password!(params[:user][:password])
      redirect_to(root_path, :notice => 'Password was successfully updated.')
    else
      render :action => "edit"
    end
  end

  private

  def resolve_layout
    case action_name
    when "edit"
      "auth"
    else
      "application"
    end
  end

end
