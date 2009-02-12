class User < ActiveResource::Base
  # http://stack.nayutaya.jp/api/users.json
  self.site = "http://stack.nayutaya.jp/api/"
  self.format = :json

  self.logger = Logger.new($stderr)

  def self.find_a(options, params = {})
    self.find(:one,
              :from => "/api/user/#{options[:user_id_type]}/#{options[:user_id]}.json",
              :params => params).response.user
  end

end
