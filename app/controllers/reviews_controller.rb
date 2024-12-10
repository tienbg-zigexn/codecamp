class ReviewsController < ApplicationController
  before_action :set_review, only: %i[destroy show]
  before_action :set_book, only: %i[new create]

  def new
    @review = @book.reviews.new
  end

  def show
    if request.headers["turbo-frame"]
      render partial: "reviews/review", locals: { review: @review }
    else
      render head :bad_request
    end
  end

  def create
    @review = @book.reviews.build(review_params)
    @review.user = Current.user

    if @review.save
      Current.user.followers.each do |follower|
        CreateNotificationJob.perform_later(follower, Current.user, 'posted', @review)
      end
      respond_to do |format|
        format.html { redirect_to @book, notice: "Review was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Review was successfully created." }
      end
    end
  end

  def destroy
    return head :unauthorized unless @review.user == Current.user

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
