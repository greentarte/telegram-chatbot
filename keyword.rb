require 'telegram/bot'
require 'rest-client'
require 'nokogiri'
token = ENV["telegram_token"]




Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    when '/manager'
        bot.api.send_message(chat_id:message.chat.id, text: "매니저님")
    when 'record'
        record = [ ]
        record_url = "http://cc.speedium.co.kr/content/05contest/03_01.jsp"
        record_html = RestClient.post(record_url, {p_code1: 'C0;C27;', p_code2: 'C0;C27;C40;', p_code3: 'C0;C27;C40;C41;'})
        record_doc = Nokogiri::HTML(record_html)

        record_doc.css("tr td").each do |a|
            record << a.text
        end

        msg=""


        record.each_with_index do |value,index| 
            if index%8==0
                msg = msg + "\n\n"
            elsif index%4==0
                msg = msg + "\n"
            end
                msg = msg + "#{value} "
            end
        
        bot.api.send_message(chat_id:message.chat.id, text: "#{msg}")
    end
  end
end