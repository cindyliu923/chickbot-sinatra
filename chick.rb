#!/usr/bin/env ruby

require 'sinatra'
require 'line/bot'
require 'dotenv/load'
require 'pry'
require './receiver'
require './replier'

post '/chick/webhook' do
  response = line.reply_message(receiver.reply_token, replier.reply)

  :ok
end

private

def line
  @line ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV['LINE_SECRET']
    config.channel_token = ENV['LINE_TOKEN']
  }
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
