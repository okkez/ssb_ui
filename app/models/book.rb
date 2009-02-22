# -*- coding: utf-8 -*-

require 'net/http'

class Book < ActiveResource::Base

  self.site = "http://stack.nayutaya.jp/api/"
  self.format = :json
  self.logger = ApplicationController.logger

  def self.find_a(options, params = {})
    self.find(:one,
              :from => "/api/book/#{options[:book_id_type]}/#{options[:book_id]}.json",
              :params => params).response
  end

  # @return Book
  def self.find_stocks(options, params = {})
    self.find(:one,
              :from => "/api/book/#{options[:book_id_type]}/#{options[:book_id]}/stocks.json",
              :params => params).response
  end

  # @return Book
  def self.find_stocks_by_state(options, params = {})
    self.find(:one,
              :from => "/api/book/#{options[:book_id_type]}/#{options[:book_id]}/stocks/#{options[:state]}.json",
              :params => params).response
  end

  # @return Book
  def self.find_stacked_stocks(options, params = {})
    self.find(:one,
              :from => "/api/book/#{options[:book_id_type]}/#{options[:book_id]}/stocks/stacked.json",
              :params => params).response
  end

  # @return Book
  def self.find_stocks_by_user(options, params = {})
    self.find(:one,
              :from => "/api/user/#{options[:user_id_type]}/#{options[:user_id]}/stocks.json",
              :params => params)
  end

  # @return Book
  def self.find_stocks_by_user_and_state(options, params = {})
    self.find(:one,
              :from => "/api/user/#{options[:user_id_type]}/#{options[:user_id]}/stocks/#{options[:state]}.json",
              :params => params)
  end

  # @return Book
  def self.find_stacked_stocks_by_user(options, params = {})
    self.find(:one,
              :from => "/api/user/#{options[:user_id_type]}/#{options[:user_id]}/stocks/stacked.json",
              :params => params).response
  end

  # 自分のしか更新できない
  # http://stack.nayutaya.jp/api/[User ID]/[API Token]/stocks/update.1
  def self.update_a(book = {})
    body = [
            {
              :asin   => book[:asin], # ISBN10
              :date   => book[:date],
              :state  => book[:state],
              :public => book[:public],
            }
           ]
    # TODO use ActiveResource
    user = SsbConfig.user
    token = SsbConfig.token
    response = nil
    Net::HTTP.start("stack.nayutaya.jp", 80) do |http|
      uri = "/api/#{user}/#{token}/stocks/update.1"
      response = http.post(uri, "request=#{URI.encode(body.to_json)}")
    end
    Book.new(ActiveSupport::JSON.decode(response.body))
  end

end
