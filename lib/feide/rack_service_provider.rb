require 'saml'
require 'rack'

module Feide
  class RackServiceProvider

    def initialize(app, opts)
      @meta = SAML::Metadata::EntitiesDescriptor.from_xml(opts[:meta])
      @app  = app

      handler_class = opts[:handler_class] || SAMLHandler
      @handler_obj = handler_class.new(@meta)
      
      @dispatch = {
        'GET' => {
          '/feide/signon' => :signon,
          '/feide/logout' => :logout,
            @meta.sp_single_logout_service.location.path => :consume_logout,
        },
        'POST' => {
          @meta.sp_assertion_consumer_service.location.path => :consume,
        },
      }
    end
    
    def call(env)
      response = dispatch(Rack::Request.new(env), Rack::Response.new)
      return response unless response.nil?
      @app.call(env)
    end

    def dispatch(request, response)
      return unless %w(GET POST).find(request.request_method)
      handler = @dispatch[request.request_method][request.path_info]
      return if handler.nil?
      @handler_obj.method(handler).call(request, response)
    end
  
  end
end
