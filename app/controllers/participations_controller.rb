#
# ParticipationsController
#
class ParticipationsController < ApplicationController
  before_action :authenticate_admin, only: [:update]
  before_action :set_participation, only: [:update]
  before_action :set_presentation, only: [:update]
  before_action :set_presenter, only: [:update]

  #
  # Update route
  #
  def update
    handle_participation_survey

    if @participation.update(participation_params)
      redirect_to presentation_path(params[:presentation_id]), notice: 'Participation was successfully updated.'
    else
      render presentation_path(params[:presentation_id])
    end
  end

  private

  #
  # Set Participation to be used in routes
  #
  def set_participation
    @participation = Participation.find(params[:id])
  end

  #
  # Set Presentation to be used in routes
  #
  def set_presentation
    @presentation = Presentation.find(@participation.presentation_id)
  end

  #
  # Set presenter (User) to be used in routes
  #
  def set_presenter
    @presenter = User.find(@participation.user_id)
  end

  #
  # Set and sanitaize participation params
  #
  def participation_params
    params.require(:participation).permit(:user_id, :presentation_id, :is_presenter)
  end

  #
  # Create or Delete surveys when creating new participations
  #
  def handle_participation_survey
    # If creating new presenter, create a survey for the presenter
    if participation_params[:is_presenter] == 'true' # Why is this a string?
      new_default_survey(@presenter)
    elsif @presentation.surveys.where(presenter_id: @presenter.id).exists?
      # Otherwise, delete the presenter's survey(s)
      survey = @presentation.surveys.where(presenter_id: @presenter.id) # Returns array
      survey.destroy_all
    end
  end
end
