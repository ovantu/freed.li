class EvaluationsController < ApplicationController
  
  # TO DO method to check if 2/3 have been accepted or declined and change post status
  
  
  # POST /evaluations/1
  def accept_post
    evaluation = Evaluation.where(user_id: current_user.id, post_id: params[:id]).first
    evaluation.update(status: "accepted")
    redirect_to feed_path(evaluation.post.feed.id), notice: 'Post was accepted.'
  end
  
  # DELETE /evaluations/1
  def decline_post
    evaluation = Evaluation.where(user_id: current_user.id, post_id: params[:id]).first
    evaluation.status = "decline"
    evaluation.save
    redirect_to feed_path(evaluation.post.feed.id), notice: 'Post was declined.'
  end
  
  # PUT /evaluations/1
  def pass_post
    post = Post.find(params[:id])
    evaluation = Evaluation.where(user_id: current_user.id, post_id: post.id).first
    evaluation.status = "passed"
    evaluation.save
    assign_new_evaluator(post)
    redirect_to feed_path(post.feed.id), notice: 'Post was passed on.'
  end
  
  private
  
  def assign_new_evaluator(entry)
    # remove the creator and other evaluators of this post
    possible_evaluators = entry.feed.contributors - [entry.creator_id] - entry.all_evaluators
    # select a random evaluator
    evaluator = possible_evaluators.sample
    # set the pending evaluation
    entry.evaluations.build(user_id: evaluator, status: "pending")
  end
  
end
