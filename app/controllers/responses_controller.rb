#
# ResponsesController
#
class ResponsesController < ApplicationController
  def new # TODO: requires cleanup
    set_instance_variables

    # TODO: Check if responses already exist (maybe as before_action)

    @responses = []
    @questions.each do |question|
      @responses << question.responses.new(user_id: current_user.id)
    end
  end

  def create # TODO: requires cleanup
    set_instance_variables

    @responses = []
    @questions.each do |question|
      @responses << question.responses.new(
        user_id: current_user.id,
        value:   response_params[:question_id]["#{question.id.to_s}"]
      )
    end

    all_valid = true

    @responses.each do |response|
      next if response.valid?
      all_valid = false
    end

    if all_valid
      @responses.each do |response|
        response.save
      end
      redirect_to presentation_path(@presentation)
    else
      # TODO: Handle invalid response submition (notices, error messages, etc.)
      render :new
    end
  end

  # def show
  #
  # end

  private

  #
  # Set and sanitize response parameters
  #
  def response_params
    params.require(:responses).permit!
  end

  #
  # Set variables to be used in routes
  #
  def set_instance_variables
    @presentation = Presentation.find(params[:presentation_id])
    @surveys = @presentation.order_surveys
    @questions = Question.where(survey_id: @surveys.pluck(:id))
  end
end
