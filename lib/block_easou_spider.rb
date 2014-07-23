require 'rack'
require 'logger'
class Rack::BlockEasouSpider
  DEFAULT_CONTENT_TYPE = 'text/html'
  DEFAULT_CHARSET      = 'utf-8'
  EASOU_UA_REGEX       = /EasouSpider/
 
  attr_reader :logger
  def initialize(app, stdout=STDOUT)
    @app = app
    @logger = defined?(Rails.logger) ? Rails.logger : Logger.new(stdout)
  end
 
  def call(env)

    # calling env.dup here prevents bad things from happening
    request = Rack::Request.new(env.dup)

    unless request.user_agent && request.user_agent =~ EASOU_UA_REGEX
      return @app.call(env)
    end

    @logger.debug "Blocking EasouSpider request."

    content_type = env['HTTP_ACCEPT'] || DEFAULT_CONTENT_TYPE
    status = 403
    body   = "EasouSpider is forbidden."
    return [
      status,
      {
         'Content-Type' => "#{content_type}; charset=#{DEFAULT_CHARSET}",
         'Content-Length' => body.bytesize.to_s
      },
      [body]
    ]
  end
 
end
