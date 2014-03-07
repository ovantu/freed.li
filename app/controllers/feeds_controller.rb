class FeedsController < ApplicationController
  before_filter :authenticate_user!
  # load_and_authorize_resource 
  before_action :set_feed, only: [:show, :edit, :update, :destroy]

  # GET /feeds
  # GET /feeds.json
  def index
    @active_feeds = Feed.all_active.where(lang: current_user.feedlang).order(created_at: :desc).first(20)
    @free_feeds = Feed.all_free.where(lang: current_user.feedlang).order(created_at: :desc).first(20)
    @users_feeds = Feed.all_contributed_feeds(current_user.id)
    @created_feeds = Feed.where(creator_id: current_user.id)
    @feeds_to_evaluate = Feed.all_feeds_user_needs_to_evaluate(current_user.id)
    
    # render stream: true
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    # posts the user has to evaluate
    # @posts_to_evaluate = current_user.posts_to_be_evaluated_in_feed(params[:id])  FROM user model
    @posts_to_evaluate = Post.joins(:evaluations).where(evaluations:{status:"pending", user_id: current_user.id}).where(feed_id: params[:id])
    # user's posts which are still in_evaluation to show in a list
    # @users_posts = current_user.own_posts_in_evaluation_and_feed(params[:id])
    @users_posts = Post.where(status: ["in_evaluation", "free"], creator_id: current_user.id, feed_id: params[:id])
    # posts the user evaluated (accepted or declined or passed) but are still in_evaluation to show in a list
    # @evaluated_posts = current_user.posts_in_evaluation(params[:id])
    @evaluated_posts = Post.joins(:evaluations).where(evaluations:{status: ["accepted", "declined", "passed"], user_id: current_user.id}).where(status: "in_evaluation", feed_id: params[:id]).eager_load(:evaluations)
    # all active posts (TO DO: check is eager_load is better for SQL server) with eager load of their creators (makes one big query instead of a query for each post)
    @posts = Post.where(status: "active", feed_id: params[:id]).eager_load(:creator)
    
    # render stream: true
  end

  # GET /feeds/new
  def new
    @new_feed = Feed.new(creator_id: current_user.id)
    @new_feed.lang = I18n.locale
  end

  # GET /feeds/1/edit
  # def edit
  # end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(feed_params)
    # a freshly created feed is "free" like the posts in it; later it becomes "active" and the posts "in_evaluation" 
    @feed.status = "free"
    respond_to do |format|
      if @feed.save
        format.html { redirect_to @feed, notice: t('feed_create_success') }
        format.json { render action: 'show', status: :created, location: @feed }
      else
        format.html { render action: 'new' }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feeds/1
  # PATCH/PUT /feeds/1.json
  # def update
  #   respond_to do |format|
  #     if @feed.update(feed_params)
  #       format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @feed.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  # def destroy
  #   @feed.destroy
  #   respond_to do |format|
  #     format.html { redirect_to feeds_url }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params.require(:feed).permit(:goal, :rule1, :rule2, :rule3, :rule4, :rule5, :misc, :description, :lang, :status, :creator_id)
    end
end
