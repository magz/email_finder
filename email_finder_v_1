#!/usr/bin/env ruby
require "open-uri"
require "json"


X_SESSION_TOKEN = 'BAgiX0FtcFMydVcyMnE0OUs1elN4N3BiZjdJekdaQzR5b201SFM1R0ZaUGJIZnUxUEI0Vm9EcThsWEM5d1FOeUVDV0otLW91dndka2ZpRE1vR1dPUDM4TVZ1OXc9PQ==--87f771d7a58bef7c6718365744c046b54b335735'
def request_headers
  {"X-Session-Token"=> X_SESSION_TOKEN}
end
def request_results

  address_permutations.map do |addr|
    puts "asking about: #{addr}"
    request_url = "https://profiles.rapportive.com/contacts/email/#{addr}?viewport_height=782&view_type=cv&user_email=michael%40namely.com&client_version=ChromeExtension+rapportive+1.4.1&client_stamp=1386264608"

    request_result = open(request_url, request_headers)
    read_request_result = JSON.parse(request_result.read)

    if read_request_result["contact"]["first_name"] != ""
      [addr.gsub("%40", "@"), true]
    else
      [addr.gsub("%40", "@"), false]
    end
  end
end

def address_permutations
  addresses = []
  addresses << @first_name
  addresses << @last_name
  addresses << @first_name + "." + @last_name
  addresses << @first_name + "_" + @last_name
  addresses << @first_name + @last_name

  addresses << @first_name[0] + @last_name
  addresses << @first_name[0] + "." + @last_name
  addresses << @first_name[0] + "-" + @last_name

  addresses << @first_name + @last_name[0]

  addresses << @last_name + @first_name[0]


  addresses.map {|addr| addr + "%40#{@domain}"}
end

while true
  puts "Welcome to the automated Rapportive API email guesser!"
  puts "What is the Target Domain? e.g. gmail.com"
  @domain = gets.strip.gsub("@", "")
  puts "first name?"
  @first_name = gets.strip
  puts "last name?"
  @last_name = gets.strip
  request_results.each do |result|
    puts "#{result[1]}: #{result[0]}"
  end
end