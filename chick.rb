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
def received_text
  @params = JSON.parse request.body.read
  message = @params['events'][0]['message']
  message['text'] unless message.nil?
end

# 關鍵字回覆
def keyword_reply(received_text)
  received_text.tr('嗎', '').tr('?？', '!！')
end

# 傳送訊息到 line
def reply_to_line(reply_text)
  return nil if reply_text.nil?

  # 取得 reply token
  reply_token = @params['events'][0]['replyToken']

  # 設定回覆訊息
  message = {
    type: 'text',
    text: reply_text
  }

  # 傳送訊息
  line.reply_message(reply_token, message)
end

post '/chick/webhook' do

  # 設定回覆文字
  reply_text = keyword_reply(received_text)
  # 傳送訊息到 line
  response = reply_to_line(reply_text)

  # 回應 200
  :ok

end
