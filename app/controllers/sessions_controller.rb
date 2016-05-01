class SessionsController < ApplicationController
  before_filter do
    @html_title = "Identificação em RD Custom Fields"
  end

  def new
  end

  def create
    if params[:register] == 'on'
      new_user = User.new
      new_user.email = params[:email]
      new_user.password = params[:password]
      if new_user.save
        session[:user_id] = new_user.id
        flash[:info] = "Bem-vindo #{new_user.email}"
        redirect_to(contacts_url) && return
      else
        flash[:danger] = "Não foi possível criar um novo usuário"
      end
    else
      status, payload = User.authenticate(params[:email], params[:password])
      if status == :ok
        session[:user_id] = payload.id
        flash[:info] = "Olá <b>#{payload.email}</b>"
        redirect_to(session[:redirect_back] || contacts_url)
        return
      elsif payload == :email
        flash[:danger] = "E-mail não cadastrado"
      elsif payload == :password
        flash[:danger] = "Senha errada"
      end
    end
    redirect_to new_sessions_path
  end

  def destroy
    flash[:info] = "Sessão de <b>#{current_user.email}</b> finalizada." if logged_in?
    session[:user_id] = nil
    redirect_to new_sessions_path
  end
end
