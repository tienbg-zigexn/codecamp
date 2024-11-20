class ReviewsController < ApplicationController
  before_action :set_review, only: %i[destroy]
  before_action :set_book, only: %i[new create]

  def new
    @review = @book.reviews.new
  end

  def create
    @review = @book.reviews.build(review_params)

    if @review.save
      respond_to do |format|
        format.html { redirect_to @book, notice: "Review was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Review was successfully created." }
      end
    end
  end

  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to @book, notice: "Review was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Review was successfully destroyed." }
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:content)
  end
end
