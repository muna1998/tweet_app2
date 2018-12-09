class PostsController < ApplicationController

before_action :authenticate_user
before_action :ensure_correct_user,{only:[:edit,:update,:destroy]}

  def ensure_correct_user
    @post=Post.find_by(id: params[:id])
    if @current_user.id != @post.user_id
      flash[:notice]="不正アクセス"
      redirect_to("/posts/index")
    end
  end

  def index
    @posts=Post.all.order(created_at: :desc)
  end

  def show
    @post=Post.find_by(id: params[:id])
    @user=@post.user
    @likes_count=Like.where(post_id: @post.id).count
  end

  def new
    @post=Post.new
  end

  def create
    @post=Post.new(
      content: params[:content],
      user_id: @current_user.id)
    if @post.save
      redirect_to("/posts/index")
      flash[:notice]="投稿しました"
    else
      render("/posts/new")
    end
  end

  def edit
    @post=Post.find_by(id: params[:id])
  end

  def update
    @post=Post.find_by(id: params[:id])
    @post.content=params[:content]
    if @post.save
      redirect_to("/posts/index")
      flash[:notice]="投稿を編集しました"
    else
      render("/posts/edit")
    end
  end

  def destroy
    @post=Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice]="削除しました"
    redirect_to("/posts/index")
  end

end
