# -*- coding: utf-8 -*-
class Stock < ActiveResource::Base
  self.site = "http://stack.nayutaya.jp/api/:user/:token/"
  self.format = :json
  self.logger = ApplicationController.logger

  # 自分のしか更新できない
  def self.update_a(book = {})
    body = [
            {
              :asin   => book[:asin], # ISBN10
              :date   => book[:date],
              :state  => book[:state],
              :public => book[:public],
            }
           ]
    # FIXME broken
    self.connection.post("update.1",
                         "request=#{URI.encode(body.to_json)}")
  end

end
