class FeedsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_feed, only: [:show, :edit, :update, :destroy]

  # GET /feeds
  # GET /feeds.json
  def index
    @adolescent_feeds = Feed.all_adolescent
    @toddler_feeds = Feed.all_toddlers
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    # posts the user has to evaluate
    # @users_evaluations = current_user.posts_to_be_evaluated_in_feed(params[:id])  FROM user model
    @users_evaluations = Post.joins(:evaluations).where(evaluations:{status:"pending", user_id: current_user.id}).where(feed_id: params[:id])
    # user's posts which are still in_evaluation
    # @users_posts = current_user.own_posts_in_evaluation_and_feed(params[:id])
    @users_posts = Post.where(status: ["in_evaluation", "free"], creator_id: current_user.id, feed_id: params[:id])
    # posts the user evaluated (accepted or declined) but are still in_evaluation
    # @evaluated_posts = current_user.posts_in_evaluation(params[:id])
    @evaluated_posts = Post.joins(:evaluations).where(evaluations:{status: ["accepted", "declined"], user_id: current_user.id}).where(status: "in_evaluation", feed_id: params[:id]).eager_load(:evaluations)
    # all active posts (TO DO: check is eager_load is better for SQL server)
    @posts = Post.where(status: "active", feed_id: params[:id]).eager_load(:creator)
  end

  # GET /feeds/new
  def new
    @feed = Feed.new(creator_id: current_user.id)
    @feed.lang = I18n.locale
  end

  # GET /feeds/1/edit
  def edit
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(feed_params)
    @feed.status = "toddler"
    respond_to do |format|
      if @feed.save
        format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
        format.json { render action: 'show', status: :created, location: @feed }
      else
        format.html { render action: 'new' }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feeds/1
  # PATCH/PUT /feeds/1.json
  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params.require(:feed).permit(:goal, :rule1, :rule2, :rule3, :rule4, :rule5, :misc, :description, :lang, :status)
    end
end
