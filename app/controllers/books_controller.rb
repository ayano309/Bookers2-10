class BooksController < ApplicationController
   before_action :authenticate_user!
   before_action :correct_user, only:[:edit, :update]
   
  def index
   
    if params[:latest]
      @books = Book.latest
    elsif params[:old]
      @books = Book.old
    elsif params[:star_count]
      @books = Book.star_count
    else
      @books = Book.all
    end
    
    @book = Book.new
    @user = current_user
    
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @newbook = Book.new
    @comment = Comment.new
    @comments = @book.comments
  end
  
  def create
    @book = current_user.books.build(book_params)
     # 受け取った値を,で区切って配列にする
    tag_list = params[:book][:name].split(',')
    if @book.save
       @book.save_tag(tag_list)
      redirect_to book_path(@book), notice: 'You have created book successfully.'
    else
      @books = Book.all
      @user = current_user
      render :index
    end
  end
  
  def edit
    @book = Book.find(params[:id])
    @user = @book.user
    
  end
  
  def update
    @book = current_user.books.find(params[:id])
    if @book.update(book_params)
       redirect_to book_path(@book),notice: 'You have updated book successfully.'
    else
      render :edit
    end
    
  end
  
  def destroy
    book = current_user.books.find(params[:id])
    book.destroy!
    redirect_to books_path, notice: 'Book was successfully destroyed.'
    
  end
  
  private 
  
  def book_params
    params.require(:book).permit(:title,:body,:rate)
    
  end
  
  def correct_user
    @book = Book.find(params[:id])
    redirect_to books_path unless @book.user == current_user
  end
  
end
