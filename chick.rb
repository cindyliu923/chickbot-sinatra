#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'line/bot'
require 'dotenv/load'
require 'pry'
require './receiver'
require './replier'

post '/chick/webhook' do
  line.reply_message(receiver.reply_token, replier.reply)

  :ok
end

private

def line
  @line ||= Line::Bot::Client.new do |config|
    config.channel_secret = ENV['LINE_SECRET']
    config.channel_token = ENV['LINE_TOKEN']
  end
end

def line_params
  @line_params ||= JSON.parse(request.body.read)
end

def receiver
  @receiver ||= Receiver.new(line_params)
end

def replier
  @replier ||= Replier.new(receiver.message)
end
