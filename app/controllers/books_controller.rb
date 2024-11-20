class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    if params[:query].present?
      @books = Book.search(params[:query]).ordered.limit(10).includes(:reviews)
    else
      @books = Book.all.ordered.limit(10).includes(:reviews)
    end
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
      respond_to do |format|
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Book was successfully created." }
      end
    else
      render :new, notice: "Book was not created.", status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      respond_to do |format|
        format.html { redirect_to @book, notice: "Book was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Book was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity, notice: "Book was not updated."
    end
  end

  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_path, notice: "Book was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Book was successfully destroyed." }
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :description)
  end
end
