class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = Book.all.includes(:reviews)
  end

  def new
    @book = Book.new
  end

  def edit; end

  def show
    @reviews = @book.reviews
  end

  def create
    @book = Book.build(book_params)

    if @book.save
      redirect_to @book, notice: "Book was successfully created."
    else
      render :new, notice: "Book was not created.", status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Book was successfully updated."
    else
      render :edit, status: :unprocessable_entity, notice: "Book was not updated."
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "Book was successfully destroyed."
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :description)
  end
end
