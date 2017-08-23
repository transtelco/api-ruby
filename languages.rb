require "cuba"
require "cuba/safe"
require "json"
require "diplomat"
require "socket"

hostname = Socket.gethostname
puts "URL: http://#{hostname}:5001"

Diplomat.configure do |config|
  config.url = "http://#{ENV['CONSUL_HOST']}:#{ENV['CONSUL_PORT']}" 
end

Diplomat::Service.register({ 
  name: "api-ruby",
  address: hostname,
  port: 5001,
  tags: ["language"],
  checks: [{
    url: "http://#{hostname}:#{5001}/health",
    interval: "5s"
  }]
})

likes=0
Cuba.use Rack::Session::Cookie, :secret => "__a_very_long_string__"

Cuba.plugin Cuba::Safe

Cuba.define do
        on get do
                on "health" do
                        puts "GET - health"
                        res.status = 200
                        res.write "healthy"
                end

                on "language" do
                        res.write(JSON.dump({ 
                                name: 'ruby',
                                description: 'a dying language',
                                likes: likes 
                        }))

                end

                on root do
                        res.redirect "/language"
                end
        end
        on post do
                on "language/like" do
                        likes=likes+1
                        res.write(JSON.dump({ 
                                name: 'ruby',
                                description: 'a dying language',
                                likes: likes 
                        }))
                end
        end
end
