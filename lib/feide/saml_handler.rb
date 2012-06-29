require 'saml'
require 'rack'

module Feide

  # Implementation of Single Sign On and Single Logout SAML profiles. 
  #
  # Used by Feide::RackServiceProvider, and typically not used directly by
  # users of this Library. However, if you don't care for Rack, use
  # this class and not Feide::RackServiceProvider.
  #
  # All methods take the following parameters:
  #
  # env:: Hash. Rack env. Used to communicate SAML responses to the
  #       application.
  # request:: Rack::Request
  # response:: Rack::Response
  class SAMLHandler

    # @param [SAML::Metadata::EntitiesDescriptor] meta Metadata describing Feide and your service
    def initialize(meta)
      @meta = meta
      
      @assertion_consumer_service = @meta.sp_assertion_consumer_service
      @single_logout_service      = @meta.sp_single_logout_service
    end
  
    # Creates a SSO request, returning a Rack::Response that can be
    # used to redirect the browser to Feide's signon page.
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
    
    # Consumes a SAML singnon response. Result can be red from env['X-SAMLResponse']
    def consume(env, request, response)
      saml_resp = SAML::Bindings.from_endpoint(@assertion_consumer_service).build_response(request)
      saml_resp.core_response.validate(@meta.idp.idp_sso_descriptors.first.signing_key_descriptor.x509_certificate)
      env['X-SAMLResponse'] = saml_resp
      nil
    end

    def logout(env, request, response)
      saml_req = SAML::Core::LogoutRequest.new

      # FIXME validate these attributes
      saml_req.name_id = request.params['user'] 
      saml_req.session_index = request.params['session_index']

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
