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
      contents: { role: 'user', parts: { text: message } }
    })
    results.map { |result| result['candidates'][0]['content']['parts'][0]['text'] }.join('')
  end
end
