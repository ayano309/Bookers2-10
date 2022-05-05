class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @search = params[:search]
    @word = params[:word]

    if @range == "User"
      @users = User.looks(@search,@word)
    elsif @range == "Book"
      @books = Book.looks(@search,@word)
    elsif @range == "Tag"
      @books = Tag.search_books_for(@search,@word)
    end

  end

end