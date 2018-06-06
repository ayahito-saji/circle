class SocialProfile < ApplicationRecord
  belongs_to :user

  def set_values(omniauth)
    return if provider.to_s != omniauth['provider'].to_s || uid != omniauth['uid']
    credentials = omniauth['credentials']
    info = omniauth['info']

    self.access_token = credentials['refresh_token']
    self.access_secret = credentials['secret']
    self.credentials = credentials.to_json
    self.name = info['name']
    self.set_values_by_raw_info(omniauth['extra']['raw_info'])
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end
end
