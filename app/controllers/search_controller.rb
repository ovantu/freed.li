class SearchController < ApplicationController
before_filter :authenticate_user!
  def show
    @found_posts = Post.search_active(params[:query]).eager_load(:feed, :creator)
    @found_feeds = Feed.search(params[:query])
    
    # For formatting reasons
    @created_feeds = Feed.where(creator_id: current_user.id)
    @feeds_to_evaluate = Feed.all_feeds_user_needs_to_evaluate(current_user.id)
  end
end
