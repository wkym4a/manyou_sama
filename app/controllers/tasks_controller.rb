class TasksController < ApplicationController
  PER = 8

  before_action :set_tasks , only: [:show , :edit , :update ,:update_status , :destroy ]

  #一覧画面表示
  def index

    #初期表示時は、画面に情報を表示しない
    #指摘を受けて、jsにて初期表示時は全件表示するように変更
    @tasks = Task.none

  end
  def index_search

    @tasks = Task.new.search_tasks(params[:conditions])
    @tasks = Kaminari.paginate_array(@tasks).page(params[:page]).per(PER)#step17で追加
    # @tasks = Task.all.order(created_at: "desc")
    respond_to do |format|
        # format.html
        format.js { render :index_box }
    end
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

    #ユーザーモデルがまだないため、いったんユーザーはすべて「1」とする。
      @task.user_id = 1

    respond_to do |format|
# t('action.search')
 # t("errors.messages.is_invalid_info", this: t('activerecord.attributes.task.status'))
      if @task.save
        format.html{redirect_to edit_task_path(@task) , notice: t('activerecord.normal_process.do_save') }
      else
        format.html{render "new"}
      end
    end
  end

  #更新処理
  def update

    respond_to do |format|

      if @task.update(task_params)==true
        format.html{redirect_to edit_task_path(@task) , notice: t('activerecord.normal_process.do_update') }
      else
        format.html{render "edit"}
      end
    end
  end

  #進捗の更新（一覧画面で行う
  def update_status

    respond_to do |format|
      @line_num = params[:task][:line_num]
      if @task.update( status:  params[:task]["status_" + @task.id.to_s]) ==true
        flash[:notice]  = t("activerecord.normal_process.do_update_this", this: t('activerecord.attributes.task.name') + "【" + @task.name + "】")
        format.js { render :index_line }
      else
        flash[:notice]  = t('activerecord.errors.failed_save')
        format.js { render :index_line }
      end
    end

  end

  #削除処理
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_path, notice: t("activerecord.normal_process.do_del", this: t('activerecord.models.task')) }

    end
  end
  ####↑データ登録処理↑###

  def set_tasks
    @task=Task.find(params[:id])
  end

  def task_params
    param_info = params.require(:task).permit(:name,:content,:limit,:priority,:status)
    #ユーザーモデルがまだないため、ユーザーidについてはいったん保留……とりあえず、ほかで「1」となるようせっていしているはず。
  end

  def reset_task
  #ユーザーモデルがまだないため、いったんユーザーはすべて「1」とする。
    @task.user_id = 1
    @task.name = task_params[:name]
    @task.content = task_params[:content]
    @task.limit = task_params[:limit]
    @task.priority = task_params[:priority]
    @task.status = task_params[:status]
  end

end
