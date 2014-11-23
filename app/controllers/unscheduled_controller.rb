class UnscheduledController < ApplicationController
  def view
    @course = Course.find(params[:id])
    render 'studygroups/unscheduled_view/'
  end
end
