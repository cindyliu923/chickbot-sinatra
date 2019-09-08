#!/usr/bin/env ruby

require 'sinatra'
require 'line/bot'
require 'dotenv/load'

# Line Bot API 物件初始化
def line
  @line ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV['LINE_SECRET']
    config.channel_token = ENV['LINE_TOKEN']
  }
end

# 取得對方說的話
def received_message
  @params = JSON.parse request.body.read
  @params['events'][0]['message']
end

# 關鍵字回覆
def keyword_reply(message)
  message['text'].tr('嗎', '').tr('?？', '!！')
end

# 設定回覆訊息
def reply_message
  message = received_message
  case message['type']
  when 'text'
    { type: 'text',
      text: keyword_reply(message) }
  when 'sticker'
    { type: 'sticker',
      packageId: '11537',
      stickerId: '52002753' }
  end
end

# 傳送訊息到 line
def reply_to_line(reply_message)
  return nil if reply_message.nil?

  # 取得 reply token
  reply_token = @params['events'][0]['replyToken']

  # 傳送訊息
  line.reply_message(reply_token, reply_message)
end

post '/chick/webhook' do
  # 傳送訊息到 line
  response = reply_to_line(reply_message)

  # 回應 200
  :ok
end
