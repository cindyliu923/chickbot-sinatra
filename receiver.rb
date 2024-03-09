# frozen_string_literal: true

# Receiver from line
class Receiver
  def initialize(params)
    @params = params
  end

  def message
    @message ||= event['message']
  end

  def reply_token
    @reply_token ||= event['replyToken']
  end

  def user_id
    @user_id ||= event['source']['userId']
  end

  private

  def event
    @event ||= @params['events'][0]
  end
end
