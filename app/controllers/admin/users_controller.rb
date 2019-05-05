class Admin::UsersController < ApplicationController
  #事前の権限チェック
  before_action :is_admin?

  before_action :set_user, only: [:edit, :edit_password,:update,:update_password, :destroy,:show]

  before_action :cannot_delete_myself, only: [:destroy]

  #一覧画面表示
  def index
    @user = User.new
    @users_index = User.new.get_users_index
  end

  ####↓「_form」をもとにした画面を開く↓###
  #新規画面表示
  def new
    @user=User.new
  end

  #更新画面
  def edit
  end
  #パスワード更新画面
  def edit_password
  end
  ####↑「_form」をもとにした画面を開く↑###

  def show
    @tasks=Task.where(user_id: @user.id).order(created_at: "DESC")
  end


  ####↓データ登録処理↓###
  #新規登録
  def create
    @user = User.new(user_params(0))

    if @user.save(context: :have_pass)
      #新規登録後は一覧画面へ
      redirect_to admin_users_path, notice: t('activerecord.normal_process.do_save')
    else
      render :new
    end
  end

  #更新処理
  def update
    respond_to do |format|
      @user.current_user_id = current_user.id#バリデーションチェック用にcurrent_userをインスタンス変数に渡す
      @user.attributes=(user_params(1))
      if @user.save(context: :change_admin)
      # if @user.update(user_params(1))==true
        #更新後は更新画面の表示を維持
        format.html{redirect_to edit_admin_user_path(@user.id) , notice: t('activerecord.normal_process.do_update')}
      else
        @task=Task.new
        @task.errors.add(:name, "rrrrrr")
         format.html{render "edit"}
        # format.html{render edit_admin_user_path(@user)}
      end
    end
  end

  def update_password
    @user.attributes=(user_params(2))
    if @user.save(context: :have_pass)
      #パスワード更新の場合、更新後は一覧画面へ
      redirect_to admin_users_path, notice: t("activerecord.normal_process.do_update_this", this: t('activerecord.attributes.user.password'))
    else
      render edit_password_admin_userpath(@user.id)
    end
  end

  #削除処理
  def destroy
    # @user.current_user_id = current_user.id#バリデーションチェック用にcurrent_userをインスタンス変数に渡す
    @user.destroy
    redirect_to admin_users_path, notice: t('activerecord.normal_process.do_del',this:t('activerecord.models.user'))
  end

private

  def set_user
    @user=User.find(params[:id])
  end

  def user_params(type)
    #type……「0:新規登録時、すべての値を返す」
    #      「1:更新時、パスワード以外の値を返す」
    #      「2:パスワード変更時、（新たに登録する）パスワードを返す」
    case type
    when 0
      return params.require(:user).permit(:cd,:name,:email, :password, :password_confirmation)
    when 1
      return params.require(:user).permit(:cd,:name,:email,:admin_status)

    when 2
      return params.require(:user).permit(:password, :password_confirmation)
    else
      return nil
    end
  end

  def cannot_delete_myself
    if @user.id == current_user.id
      # errors.add(:id, t("activerecord.errors.messages.restrict_dependent_destroy.myself"))
      # flash[:errors] =  t("activerecord.errors.messages.restrict_dependent_destroy.myself")
      redirect_to admin_users_path ,notice:t("activerecord.errors.messages.restrict_dependent_destroy.myself")
    end
  end
end
