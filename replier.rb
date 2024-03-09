# frozen_string_literal: true

# Replier to line
class Replier
  TEXT = 'text'
  SITICKER = 'sticker'
  SITICKER_ID = %w[
    52002734 52002735 52002736 52002737 52002738 52002739
    52002740 52002741 52002742 52002743 52002744 52002745
    52002746 52002747 52002748 52002749 52002750 52002751
    52002752 52002753 52002754 52002755 52002756 52002757
    52002758 52002759 52002760 52002761 52002762 52002763
    52002764 52002765 52002766 52002767 52002768 52002769
    52002770 52002771 52002772 52002773
  ].freeze

  def initialize(message, ai = nil)
    @message = message
    @ai = ai
    @type = message['type']
  end

  def reply
    send(@type)
  end

  private

  def sticker
    {
      type: SITICKER,
      packageId: '11537',
      stickerId: SITICKER_ID.sample
    }
  end

  def text
    {
      type: TEXT,
      text: keyword_reply
    }
  end

  def keyword_reply
    return @ai.send_message(@message[TEXT].delete_prefix('找AI').strip) if @message[TEXT].start_with?('找AI')

    @message[TEXT].tr('嗎', '').tr('?？', '!！')+' 笑死！'
  end
end
