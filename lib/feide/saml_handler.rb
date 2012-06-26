require 'saml'
require 'rack'

module Feide
  class SAMLHandler

    def initialize(meta)
      @meta = meta
      
      @assertion_consumer_service = @meta.sp_assertion_consumer_service
      @single_logout_service      = @meta.sp_single_logout_service
    end
  
    def signon(request, response)
      saml_req = SAML::Core::AuthnRequest.new
      saml_req.issuer = @meta.sp.entity_id
      endpoint = @meta.idp_single_signon_service
      SAML::Bindings.from_endpoint(endpoint).build_request(response, endpoint, saml_req)
      response
    end
    
    def consume(request, response)
      saml_resp = SAML::Bindings.from_endpoint(@assertion_consumer_service).build_response(request)
      saml_resp.valid?(@meta.idp.idp_sso_descriptors.first.signing_key_descriptor.x509_certificate)
      str = "<pre>Status success?: #{saml_resp.success?}\n"
      saml_resp.assertions.first.attribute_statement.attributes.each do |a|
        str << "  #{a.name} #{a.attribute_values}\n"
      end
      response.write(str)
      response
    end

    def logout(request, response)
      saml_req = SAML::Core::LogoutRequest.new
      saml_req.name_id = "test@feide.no"
      saml_req.issuer = @meta.sp.entity_id
      endpoint = @meta.idp.idp_sso_descriptors.first.single_logout_services.first
      SAML::Bindings.from_endpoint(endpoint).build_request(response, endpoint, saml_req)
      response
    end

    def consume_logout(request, response)
      saml_resp = SAML::Bindings.from_endpoint(@single_logout_service).build_response(request)
      str = "<pre>Status success?: #{saml_resp.success?}\n</pre>"
      response.write(str)
      response
    end

  end
end
