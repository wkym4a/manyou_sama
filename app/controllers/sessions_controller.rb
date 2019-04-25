class SessionsController < ApplicationController
  def new
  end

  def create
    user=User.find_by(cd: params[:session][:cd])
    #メールアドレスに対応するユーザーがない場合はエラーを出して抜ける
    if user==nil
      flash[:danger] = t('session.wrong_user_cd')
      render 'new'
    elsif user.authenticate(params[:session][:password])==false
      #パスワードが違う場合はエラーにして抜ける
      flash[:danger] = t('session.wrong_password')
      render 'new'
    else
      #パスワードが合っていた場合→ユーザーのidを保存→ログイン
      session[:user_id]=user.id
      redirect_to user_path(current_user) , notice: t('session.do_login')
    end
  end

  #ログアウト時処理
  def destroy
      session.delete(:user_id)
      redirect_to new_session_path , notice: t('session.do_logout')
  end

end
