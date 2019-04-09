class TasksController < ApplicationController
  before_action :set_tasks , only: [:show , :edit , :update]

  #一覧画面表示
  def index
    @tasks = Task.all
  end

  def show
  end

  ####↓「_form」をもとにした画面を開く↓###
  #新規画面表示
  def new
    if  params[:back]
      @task=Task.new(task_params)
    else
      @task=Task.new
    end
  end

  #更新画面
  def edit
    if  params[:back]
        #「バリデーションに引っかかって戻る」場合、それまでの画面情報を変数に格納
        reset_task
    end
  end
  ####↑「_form」をもとにした画面を開く↑###


  ####↓データ登録処理↓###
  #新規登録
  def create
    @task = Task.new(task_params)

    respond_to do |format|

      if @task.save
        format.html{redirect_to edit_task_path(@task) , notice: '登録に成功しました。' }
      else
        format.html{redirect_to new_task_path , notice: '登録に失敗しました。' }
      end
    end
  end

  #更新処理
  def update

    respond_to do |format|

      if @task.update(task_params)==true
        format.html{redirect_to edit_task_path(@task) , notice: '更新に成功しました。' }
      else
        format.html{redirect_to edit_task_path(@task) ,
           notice: '更新に失敗しました。もう一度更新するか、はじめからやり直してください。' }
      end
    end
  end

  #削除処理
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_path, notice: 'タスクを削除しました。' }

    end
  end
  ####↑データ登録処理↑###

  private
  def set_tasks
    @task=Task.find(params[:id])
  end

  def task_params
    param_info = params.require(:task).permit(:name,:content,:limit,:priority,:status)

    #ユーザーモデルがまだないため、いったんユーザーはすべて「1」とする。
    params[:user_id]=1
  end

  def reset_task
    @task.user_id = task_params[:user_id]
    @task.name = task_params[:name]
    @task.content = task_params[:content]
    @task.limit = task_params[:limit]
    @task.priority = task_params[:priority]
    @task.status = task_params[:status]
  end

end
