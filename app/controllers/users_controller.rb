class UsersController < ApplicationController

  before_action :set_users , only: [:show ,:show_after_create, :edit , :update , :update_password , :destroy ]

  #一覧画面表示
  def index
    @users = User.all
  end

  #閲覧画面表示
  def show
  end
  #新規登録後の確認用閲覧画面表示（ここではまだログインしていない）
  def show_after_create
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
  def edit_pass
  end
  ####↑「_form」をもとにした画面を開く↑###


  ####↓データ登録処理↓###
  #新規登録
  def create
    @user = User.new(user_params(0))

    if @user.save(context: :have_pass)
       redirect_to show_after_create_path(@user) , notice: t('activerecord.normal_process.do_save')
    else
      render :new
    end
  end

  #更新処理
  def update
    if @user.update(user_params(1))==true
      redirect_to user_path(@user.id) , notice: t('activerecord.normal_process.do_update')
    else
      render edit_user_path(@user)
    end
  end

  def update_password
    @user.attributes=(user_params(2))
    if @user.save(context: :have_pass)
      redirect_to user_path(@user.id), notice: 'パスワードを変更しました。'
    else
      render edit_pass_user_path(@user.id)
    end
  end

  #削除処理
  def destroy
    @user.destroy
    redirect_to new_session_patch
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
      return params.require(:user).permit(:cd,:name,:email)

    when 2
      return params.require(:user).permit(:password, :password_confirmation)
    else
      return nil
    end
  end

end
