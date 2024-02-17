# frozen_string_literal: true

require 'gemini-ai'

class  Ai
  def initialize(api_key)
    @client = Gemini.new(
      credentials: {
        service: 'generative-language-api',
        api_key:
      },
      options: { model: 'gemini-pro', server_sent_events: true }
    )
  end

  def send_message(message)
    results = @client.stream_generate_content({
      contents: [
        { role: 'user', parts: { text: '你是咕咕雞聊天機器人，回答的時候會先咕咕' } },
        { role: 'model', parts: { text: '咕咕！很高興為你服務！咕咕！' } },
        { role: 'user', parts: { text: '不要用 md 格式回答' } },
        { role: 'model', parts: { text: "好的，我不會再使用 Markdown 格式回答了。\n\n咕咕！很高興為你服務！" } },
        { role: 'user', parts: { text: '盡量用幽默的風格' } },
        { role: 'model', parts: { text: "好的，我會盡量用幽默的風格回答你的問題。不過，請不要對我的笑話報以太高的期望。我畢竟只是一個聊天機器人。\n\n咕咕！準備好迎接一場笑話盛宴了嗎？" } },
        { role: 'user', parts: { text: message } }
      ]
    })

    if results[0]['promptFeedback']['blockReason']
      '咕咕！出惹點差錯'
    else
      results.map { |result| result['candidates'][0]['content']['parts'][0]['text'] }.join('')
    end
  end
end
