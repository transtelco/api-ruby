require "cuba"
require "cuba/safe"
require "json"


likes=0
Cuba.use Rack::Session::Cookie, :secret => "__a_very_long_string__"

Cuba.plugin Cuba::Safe

Cuba.define do
        on get do
                on "health" do
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
