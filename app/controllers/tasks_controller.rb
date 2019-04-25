class TasksController < ApplicationController

  before_action :chk_authorioty_no_id, only: [:index, :index_search, :new ,:create,:show]
  before_action :chk_authorioty_with_id, only: [:edit, :update, :update_status, :destroy]

  PER = 8

  before_action :set_tasks , only: [:show , :edit , :update ,:update_status , :destroy ]

  #一覧画面表示
  def index

    #初期表示時は、画面に情報を表示しない
    #指摘を受けて、jsにて初期表示時は全件表示するように変更
    condition = {user_cd: current_user.cd , sort: "tasks_created_at_desc"}
    @tasks = Task.new.search_tasks(condition)
    @tasks = Kaminari.paginate_array(@tasks).page(params[:page]).per(PER)
    # @tasks = Task.none

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
      @task=Task.new(user_id: current_user.id)
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
        #グリッド表示情報の形に、「@tasks」を加工
        condition = {id: @task.id.to_s}
        @task_line = Task.new.search_tasks(condition)
        flash[:notice] = t("activerecord.normal_process.do_update_this", this: t('activerecord.attributes.task.name') + "【" + @task.name + "】")
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
    param_info = params.require(:task).permit(:name,:content,:limit,:priority,:status,:user_id)
    #ユーザーモデルがまだないため、ユーザーidについてはいったん保留……とりあえず、ほかで「1」となるようせっていしているはず。
  end

  def reset_task
    @task.name = task_params[:name]
    @task.content = task_params[:content]
    @task.limit = task_params[:limit]
    @task.priority = task_params[:priority]
    @task.status = task_params[:status]
    @task.user_id = task_params[:user_id]
  end


  #処理前の権限チェック
  #ログインしているかどうかだけチェック……新規登録（およびその確認）画面、新規登録処理
  def chk_authorioty_no_id
    if have_authorioty? ==false
      redirect_to new_session_path
    end
  end
  #変更対象投稿の作成ユーザーと同じかどうかもチェック……更新（およびその確認）画面、更新，削除登録処理
  def chk_authorioty_with_id
    if have_authorioty?(Task.find(params[:id]).user_id) ==false
      redirect_to new_session_path
    end
  end

end
