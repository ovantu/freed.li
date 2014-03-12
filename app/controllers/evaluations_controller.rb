class EvaluationsController < ApplicationController
  before_filter :authenticate_user!
  
  # POST /evaluations/1
  def accept_post
    evaluation = Evaluation.where(user_id: current_user.id, post_id: params[:id]).first
    evaluation.update(status: "accepted")
    # This notice appears if you accept, but the post remains in_evaluation
    @notice = t('post_accepted')
    check_evaluation_status(params[:id])
    redirect_to feed_path(evaluation.post.feed.id), notice: @notice
  end
  
  # DELETE /evaluations/1
  def decline_post
    evaluation = Evaluation.where(user_id: current_user.id, post_id: params[:id]).first
    evaluation.update(status: "declined")
    # This notice appears if you decline, but the post remains in_evaluation
    @notice = t('post_declined')
    check_evaluation_status(params[:id])
    redirect_to feed_path(evaluation.post.feed.id), notice: @notice
  end
  
  # PUT /evaluations/1
  def pass_post
    post = Post.find(params[:id])
    evaluation = Evaluation.where(user_id: current_user.id, post_id: post.id).first
    evaluation.update(status: "passed")
    assign_new_evaluator(post)
    redirect_to feed_path(post.feed.id), notice: t('post_passed')
  end
  
  private
  
  # this method checks if 2/3 of the evaluations are accepted or declined
  def check_evaluation_status(post_id)
    evaluations = Evaluation.where(status: ["accepted", "declined", "pending"]).where(post_id: post_id)
    ac = 0.0
    de = 0.0
    total = 0.0
    evaluations.each do |ev|
      if ev.status == "accepted"
        ac = ac + 1
      elsif ev.status == "declined"
        de = de + 1
      end
      total = total + 1
    end
    # Check if e.g. 2/3 is achieved
    if ac/total >= ACCEPT_QUOTE
      post = Post.find(post_id)   # could be refractored with the evaluations above (eager_load evaluations and save into variables)
      # here a post becomes active
      post.update(status: "active")
      # check and updates feeds contributor number and last activity
      feed_stats = post.feed.update_stats
      if feed_stats[:stage] == "changed" # check if stage up happened
        flash[:send_stage_notification] = post.feed.id # send a emails with the next action; application controller 
      end
      @notice = t('post_activated')
      post.set_too_late_evaluations
      if post.feed.status == "free"
        # changes status to active if enough active posts
        if post.feed.check_status_change_to_active
          @notice = t('feed_matured')
        end
      end
    elsif de/total > 1-ACCEPT_QUOTE
      post = Post.find(post_id)  # could be refractored with the evaluations above (eager_load evaluations and save into variables)
      post.update(status: "rejected") 
      # check and updates feeds contributor number and last activity
      post.feed.update_stats  # only stage up can happen so no checking on
      @notice = t('post_rejected')
      post.set_too_late_evaluations
    end
  end
  
  # this method exchanges an evaluator for a new one
  def assign_new_evaluator(entry)
    # remove the creator and other evaluators of this post
    possible_evaluators = entry.feed.contributors - [entry.creator_id] - entry.all_evaluators
    # select a random evaluator
    evaluator = possible_evaluators.sample
    # set the pending evaluation
    entry.evaluations.build(user_id: evaluator, status: "pending", feed_id: entry.feed_id)
    entry.save
  end
  
end
