
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    basic_action
  end
  def twitter
    basic_action
  end

  private

  def basic_action
    @omniauth = request.env['omniauth.auth']
    if @omniauth.present?
      @profile = SocialProfile.where(provider: @omniauth['provider'], uid: @omniauth['uid']).first
      unless @profile
        @profile = SocialProfile.new(provider: @omniauth['provider'], uid: @omniauth['uid'])
        email = @omniauth['info']['email'] ? @omniauth['info']['email'] : Faker::Internet.email
        @profile.user = current_user || User.create!(email: email, name: @omniauth['info']['name'], password: Devise.friendly_token[0, 20])
      end
      @profile.set_values(@omniauth)
      sign_in(:user, @profile.user)
    end
    redirect_to current_user_path
  end
end