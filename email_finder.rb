require "open-uri"
require "net/http"
require "json"

def request_headers_without_token
  {
    # "X-Session-Token" => ENV['RAPPORTIVE_SESSION_TOKEN'],
    "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36",
    "Referer" => "https://mail.google.com/mail",
    "Origin" => "https://mail.google.com",
    "Host" => "profiles.rapportive.com",
    "Accept" => "*/*",
    "Accept-Language" => "en-US,en;q=0.8"
  }
end

def request_results
  random_email = rand(36**8).to_s(36) + "%40gmail.com"
  request_headers = request_headers_without_token

  request_url = "https://rapportive.com/login_status?user_email=#{random_email}"
  puts "getting auth token for email #{random_email}"
  response = open(request_url)
  request_headers["X-Session-Token"] = JSON.parse(response.read)["session_token"]


  address_permutations.map do |addr|
    request_url = "https://profiles.rapportive.com/contacts/email/#{addr}?viewport_height=782&view_type=cv&user_email=#{random_email}&client_version=ChromeExtension+rapportive+1.4.1"

    uri = URI.parse(request_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.path, request_headers)
    response = http.request(request)

    read_request_result = JSON.parse(response.body)

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
