# 요청보내는 예
# JSON
require 'rest-client'
require 'json'
require 'nokogiri'

token = ENV["telegram_token"]
url = "https://api.telegram.org/bot#{token}/getUpdates"
res= RestClient.get(url)
res_json = JSON.parse(res)
user_id = res_json['result'][0]['message']['from']['id']

record = [ ]
url = "http://cc.speedium.co.kr/content/05contest/03_01.jsp"
html = RestClient.post(url, {p_code1: 'C0;C27;', p_code2: 'C0;C27;C40;', p_code3: 'C0;C27;C40;C41;'})
doc = Nokogiri::HTML(html)

doc.css("tr td").each do |a|
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

msg_url=URI.encode("https://api.telegram.org/bot#{token}/sendmessage?chat_id=#{user_id}&text=#{msg}")
RestClient.get(msg_url)
