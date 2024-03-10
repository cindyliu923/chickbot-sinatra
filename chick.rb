#!/usr/bin/env ruby
# frozen_string_literal: true

require 'dotenv/load' if ENV['RACK_ENV'] == 'development'

require 'sinatra'
require 'line/bot'
require 'pry'
require './receiver'
require './replier'
require './ai'

post '/chick/webhook' do
  # line.push_message(receiver.user_id, { type: 'text', text: 'push messages' })
  # https://tw.linebiz.com/column/LINEOA-2023-Price-Plan/
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
  @replier ||= Replier.new(receiver.message, ai)
end

def ai
  @ai ||= Ai.new(ENV['GOOGLE_API_KEY'])
end
