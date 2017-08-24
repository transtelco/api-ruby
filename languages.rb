require "sinatra"
require "json"
require "diplomat"
require "socket"

hostname = Socket.gethostname
port = 4567

puts "###############################"
puts "URL: http://#{hostname}:#{port}"
puts "###############################"

Diplomat.configure do |config|
  config.url = "http://#{ENV['CONSUL_HOST']}:#{ENV['CONSUL_PORT']}" 
end

Diplomat::Service.register({ 
  name: "api-ruby",
  address: hostname,
  port: port,
  tags: ["language"],
  checks: [{
    http: "http://#{hostname}:#{port}/health",
    interval: "5s"
  }]
})

likes=0

set :bind, '0.0.0.0'

get "/health" do
  "healthy"
end

get "/language" do
  JSON({ 
    name: 'ruby',
    description: 'a dying language',
    likes: likes 
  })
end

get "/" do
  "Go to /language, the good stuff is there"
end

post "/language/like" do
  likes=likes+1
  JSON({ 
    name: 'ruby',
    description: 'a dying language',
    likes: likes 
  })
end
