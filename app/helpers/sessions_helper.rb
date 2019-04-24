module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  #ログインしている（＝current_userに値が入っている）ならT、いないならFを返す
  def logged_in?
    current_user.present?
  end

  #引数である「タスクのid」が「ログインしたユーザーの仕事」ならT、そうでないならFを返す
  def your_task?(task_id)
    
    if logged_in?
      if current_user.id==Task.find(task.id).user_id
        return true
      end
    end

  end

end
