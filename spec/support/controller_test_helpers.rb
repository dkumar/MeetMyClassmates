module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @email = 'test@berkeley.edu'
      @password = 'aaaaaaaa'
      @user = User.create(@email, @password)
      sign_in @user
    end
  end
end