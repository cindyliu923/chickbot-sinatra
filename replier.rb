class Replier
  TEXT = 'text'
  SITICKER = 'sticker'

  def initialize(message)
    @message = message
    @type = message['type']
  end

  def reply
    return text if @type == TEXT
    return sticker if @type == SITICKER
  end

  private

  def text
    { type: TEXT,
      text: keyword_reply }
  end

  def keyword_reply
    @message[TEXT].tr('嗎', '').tr('?？', '!！')
  end

  def sticker
    { type: SITICKER,
      packageId: '11537',
      stickerId: '52002753' }
  end
end
