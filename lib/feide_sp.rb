require 'saml'

class FeideSP

  def initialize(app, opts)
    xml = opts[:meta]
    SAML::Metadata::XMLNamespaces.each {|k,v| xml.add_namespace(k, v)}
    @meta = SAML::Metadata::EntitiesDescriptor.from_xml(xml)
    @app = app
  end
  
  
  def call(env)
    request  = Rack::Request.new(env)
    response = Rack::Response.new
  
    assertion_consumer_service = @meta.sp.sp_sso_descriptors.first.assertion_consumer_services.first
    single_logout_service      = @meta.sp.sp_sso_descriptors.first.single_logout_services.first


   if request.request_method == 'GET' && request.path_info == '/saml/signon'
      saml_req = SAML::Core::AuthnRequest.new
      saml_req.issuer = @meta.sp.entity_id
      endpoint = @meta.idp.idp_sso_descriptors.first.single_signon_services.first
      SAML::Bindings.from_endpoint(endpoint).build_request(response, endpoint, saml_req)
      return response
    elsif request.request_method == 'POST' && assertion_consumer_service.location.path
     saml_resp = SAML::Bindings.from_endpoint(assertion_consumer_service).build_response(request)
     str = "<pre>Status success?: #{saml_resp.success?}\n"
     saml_resp.assertions.first.attribute_statement.attributes.each do |a|
        str << "  #{a.name} #{a.attribute_values}\n"
      end
     response.write(str)
     return response
   elsif request.request_method == 'GET' && request.path_info == '/saml/logout'
     saml_req = SAML::Core::LogoutRequest.new
     saml_req.name_id = "test@feide.no"
     saml_req.issuer = @meta.sp.entity_id
     endpoint = @meta.idp.idp_sso_descriptors.first.single_logout_services.first
     SAML::Bindings.from_endpoint(endpoint).build_request(response, endpoint, saml_req)
     return response
   elsif request.request_method == 'GET' && request.path_info == single_logout_service.location.path
     saml_resp = SAML::Bindings.from_endpoint(single_logout_service).build_response(request)
     str = "<pre>Status success?: #{saml_resp.success?}\n</pre>"
     str
     response.write(str)
     return response
   end
    
    @app.call(env)
  end

  private
  
end


