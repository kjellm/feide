require 'saml'
require 'rack'

module Feide
  class SAMLHandler

    def initialize(meta)
      @meta = meta
      
      @assertion_consumer_service = @meta.sp_assertion_consumer_service
      @single_logout_service      = @meta.sp_single_logout_service
    end
  
    def signon(env, request, response)
      saml_req = SAML::Core::AuthnRequest.new
      saml_req.issuer = @meta.sp.entity_id
      endpoint = @meta.idp_single_signon_service
      SAML::Bindings.from_endpoint(endpoint).build_request(response,
                                                           endpoint,
                                                           saml_req,
                                                           request.params['relay_state'])
      response
    end
    
    def consume(env, request, response)
      saml_resp = SAML::Bindings.from_endpoint(@assertion_consumer_service).build_response(request)
      saml_resp.core_response.validate(@meta.idp.idp_sso_descriptors.first.signing_key_descriptor.x509_certificate)
      env['X-SAMLResponse'] = saml_resp
      nil
    end

    def logout(env, request, response)
      saml_req = SAML::Core::LogoutRequest.new
      saml_req.name_id = request.params['user'] # FIXME verify this attribute
      saml_req.issuer = @meta.sp.entity_id
      endpoint = @meta.idp.idp_sso_descriptors.first.single_logout_services.first
      SAML::Bindings.from_endpoint(endpoint).build_request(response,
                                                           endpoint,
                                                           saml_req,
                                                           request.params['relay_state'])
      response
    end

    def consume_logout(env, request, response)
      saml_resp = SAML::Bindings.from_endpoint(@single_logout_service).build_response(request)
      env['X-SAMLResponse'] = saml_resp
      nil
    end

  end
end
