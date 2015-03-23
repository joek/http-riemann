require 'sinatra'
require 'json'
require 'riemann/client'

class RiemannHttp < Sinatra::Base

  configure  do

    use Rack::Auth::Basic, "Restricted Area" do |username, password|
      username == ENV['HTTP_USER'] and password == ENV['HTTP_PASSWORD']
    end

    enable :logging
    set :riemann_client, Riemann::Client.new(
                            host: ENV['RIEMANN_HOST'] || 'localhost',
                            port: Integer(ENV['RIEMANN_PORT'] || "5555"),
                            timeout: 5)
  end

  post '/' do
    data = JSON.parse(request.body.read, :symbolize_names => true)
    logger.info data
    settings.riemann_client << data
    JSON.generate data
  end
end


RiemannHttp.run! if __FILE__ == $0
