class UnscheduledController < ApplicationController
  def show
    p '&'*10
    p params
    @course = Course.find(params[:id])
    render 'studygroups/unscheduled_view/'
  end
end
