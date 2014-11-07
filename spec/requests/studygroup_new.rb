require 'rails_helper'
require_relative '../support/test_helpers'
require 'simplecov'
require 'spec_helper'
SimpleCov.start 'rails'

module HelperMethods
  def fill_in_form

  end
end

describe 'create page' do
  include HelperMethods
  include TestHelpers
  before(:all) do
    Capybara.current_driver = :webkit
  end
  before :each do
    login_user
  end

  it 'show error for bad data' do
  	Capybara.current_driver = :webkit

    visit ('/studygroups/new')
    fill_in('groupname', :with => "anything")
 	
 	select "3", :from => "start_hours"   
 	select "30", :from => "start_minutes"
 	select "A.M.", :from => "start_time_tag"  
 	select "4", :from => "end_hours"
 	select "30", :from => "end_minutes"
 	select "P.M.", :from => "end_time_tag" 
    #select '2011/01/01', :from => "date"
    page.execute_script("$('#date').val('21/12/1980')")
    fill_in('location', :with => "anywhere")

    click_button('Create')
    page.driver.browser.switch_to.alert.accept
    after(:all) do
    	Capybara.use_default_driver
  	end
  end



end