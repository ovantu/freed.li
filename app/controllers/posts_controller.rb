class PostsController < ApplicationController
  before_filter :authenticate_user!
  # load_and_authorize_resource 
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new(feed_id: params[:feed_id], creator_id: current_user.id)
  end

  # GET /posts/1/edit
  # def edit
  # end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    case @post.feed.anonymity
    when "all"
      @post.anonymity = "hidden"
    when "nobody"
      @post.anonymity = "visible"
    end
    
    if @post.feed.status == "free"   
      @post.status = "free"
    else 
      @post.status = "error_no_evaluations"  # should be overwriten at assign evaluations
    end
    respond_to do |format|
      if @post.save
        # get all unique contributors (depending on "free" or "active") of the feed belonging to the post in creation
        @contributors = @post.feed.contributors
        
        if @post.feed.status == "free"
          # check and change feeds contributor number and last activity; ONLY free posters become automaticaly contributors
          feed_stats = @post.feed.update_stats
          if feed_stats[:stage] == "changed" # check if stage up happened
            flash[:send_stage_notification] = @post.feed.id # send a emails with the next action; application controller 
          end
          # check how many contributors are already in the feed
          if @contributors.size >= STAGE_0_1  # Stage 1
            if free_posts = Post.free_posts(@post.feed_id)  # TO DO: maybe change it to a custom method for Feed instances
              free_posts.each do |fp|
                # assign the evaluators and create "pending" evaluations and change status to "in_evaluation"
                assign_inital_evaluators(fp, @contributors)
              end # .each
            end # if free_post

          end # Stage 1
        elsif @post.feed.status == "active"
          # NEW POST: assign the evaluators and create "pending" evaluations and change status to "in_evaluation"
          assign_inital_evaluators(@post, @contributors)
        end
        
        format.html { redirect_to feed_path(@post.feed_id), notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new', notice: @post.errors[:base]}
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  # def update
  #   respond_to do |format|
  #     if @post.update(post_params)
  #       format.html { redirect_to feed_path(@post.feed_id), notice: 'Post was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @post.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /posts/1
  # DELETE /posts/1.json
  # def destroy
  #   @post.destroy
  #   respond_to do |format|
  #     format.html { redirect_to posts_url }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :creator_id, :feed_id, :status, :anonymity)
    end
    
    def assign_inital_evaluators(entry, contributors)
      # remove the creator of this one 'free' post
      possible_evaluators = contributors - [entry.creator_id]
      # find a good number of needed_evaluators
      needed_evaluators = Math.sqrt(EVALUATOR_QUOTE*possible_evaluators.size).round.to_i
      # make sure the evaluator number is odd
      if needed_evaluators.even?
        needed_evaluators = needed_evaluators - 1
      end
      # TO DO change this times into .sample(needed_evaluators)
      # create pending evaluations for all needed_evaluators
      needed_evaluators.times do |x|
        # select a random evaluator
        evaluator = possible_evaluators.sample
        # set the pending evaluation
        entry.evaluations.build(user_id: evaluator, status: "pending", feed_id: entry.feed_id)
        # remove the evaluator
        possible_evaluators.delete(evaluator)
      end  
      # change the free posts status
      entry.update( status: "in_evaluation")
    end
    
    
end
