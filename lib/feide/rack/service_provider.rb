require 'saml'

class FeideSP

  def initialize(app, opts)
    @meta = SAML::Metadata::EntitiesDescriptor.from_xml(opts[:meta])
    @app  = app

    @assertion_consumer_service = @meta.sp.sp_sso_descriptors.first.assertion_consumer_services.first
    @single_logout_service      = @meta.sp.sp_sso_descriptors.first.single_logout_services.first

    @dispatch = {
      'GET' => {
        '/feide/signon' => method(:signon),
        '/feide/logout' => method(:logout),
        @single_logout_service.location.path => method(:consume_logout),
      },
      'POST' => {
        @assertion_consumer_service.location.path => method(:consume),
      },
    }
  end
  
  def call(env)
    response = dispatch(env)
    return response unless response.nil?
    @app.call(env)
  end

  def dispatch(env)
    request = Rack::Request.new(env)
    return unless %w(GET POST).find(request.request_method)
    handler = @dispatch[request.request_method][request.path_info]
    return if handler.nil?
    handler.call(request)
  end
  
  def signon(request)
    response = Rack::Response.new
    saml_req = SAML::Core::AuthnRequest.new
    saml_req.issuer = @meta.sp.entity_id
    puts saml_req.to_xml
    endpoint = @meta.idp.idp_sso_descriptors.first.single_signon_services.first
    SAML::Bindings.from_endpoint(endpoint).build_request(response, endpoint, saml_req)
    response
  end

  def consume(request)
    response = Rack::Response.new
    saml_resp = SAML::Bindings.from_endpoint(@assertion_consumer_service).build_response(request)
    saml_resp.valid?(@meta.idp.idp_sso_descriptors.first.signing_key_descriptor.x509_certificate)
    str = "<pre>Status success?: #{saml_resp.success?}\n"
    saml_resp.assertions.first.attribute_statement.attributes.each do |a|
      str << "  #{a.name} #{a.attribute_values}\n"
    end
    response.write(str)
    response
  end

  def logout(request)
    response = Rack::Response.new
    saml_req = SAML::Core::LogoutRequest.new
    saml_req.name_id = "test@feide.no"
    saml_req.issuer = @meta.sp.entity_id
    endpoint = @meta.idp.idp_sso_descriptors.first.single_logout_services.first
    SAML::Bindings.from_endpoint(endpoint).build_request(response, endpoint, saml_req)
    response
  end

  def consume_logout(request)
    response = Rack::Response.new
    saml_resp = SAML::Bindings.from_endpoint(@single_logout_service).build_response(request)
    str = "<pre>Status success?: #{saml_resp.success?}\n</pre>"
    response.write(str)
    response
  end
    
end


