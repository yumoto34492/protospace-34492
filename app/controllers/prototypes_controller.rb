class PrototypesController < ApplicationController
  # ログインしていないユーザーはログインページへ遷移するが、新規投稿、編集、削除は未ログインのユーザーでは実行不可能 
  before_action :authenticate_user!, only: [:new, :edit, :destroy]
  # showとeditアクションの前にset_prototypeを実行する
  before_action :set_prototype, only: [:show, :edit]
  # before_action :set_prototype_b, only: [:update, :destroy]

  def index
    # prototypeテーブルのすべてのレコードを代入
    @prototypes = Prototype.all
  end
  
  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.create(prototype_params)
    if @prototype.save
      redirect_to action: :index 
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    # 未ログイン状態かつ、ログイン中のユーザーと投稿したユーザーが異なる場合
    unless user_signed_in? && current_user.id == @prototype.user_id
      # トップページに遷移
      redirect_to action: :index     
    end
  end

  def update
    # ビューファイルへ情報を受け渡す必要がないためインスタンス変数は使用しない
    prototype = Prototype.find(params[:id])
    if prototype.update(prototype_params)
      redirect_to prototype_path(prototype.id)
    else
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to action: :index 
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype    # どのporototypeを編集するかをidで取得
    @prototype = Prototype.find(params[:id])
  end

  # def set_prototype_b    # updateとdestroyのporototypeを編集するかをidで取得
    # prototype = Prototype.find(params[:id])
  # end
end
