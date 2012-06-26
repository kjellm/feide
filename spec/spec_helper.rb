require 'feide'

META = SAML::Metadata::Document.new(<<'EOT').root
<?xml version="1.0" encoding="UTF-8" ?>
<EntitiesDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata" xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
  <EntityDescriptor entityID="ruby:gem:feide_sp">
    <SPSSODescriptor
        AuthnRequestsSigned="false"
        WantAssertionsSigned="false"
        protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
      <SingleLogoutService
          Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"
          Location="http://localhost/feide/logout" />
      <NameIDFormat>
        urn:oasis:names:tc:SAML:2.0:nameid-format:transient
      </NameIDFormat>
      <AssertionConsumerService
          index="0"
          isDefault="true"
          Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
          Location="http://localhost/feide/consume" />
    </SPSSODescriptor>
  </EntityDescriptor>
  <EntityDescriptor entityID="idp:feide">
    <IDPSSODescriptor protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
      <KeyDescriptor use="signing">
        <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
          <ds:X509Data>
            <ds:X509Certificate>[...]</ds:X509Certificate>
          </ds:X509Data>
        </ds:KeyInfo>
      </KeyDescriptor>
      <KeyDescriptor use="encryption">
        <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
          <ds:X509Data>
            <ds:X509Certificate>[...]</ds:X509Certificate>
          </ds:X509Data>
        </ds:KeyInfo>
      </KeyDescriptor>
      <SingleLogoutService
          Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"
          Location="https://localhost/feide/idp/single_logout_service"
          ResponseLocation="https://localhost/feide/idp/single_logout_service_response"/>
      <NameIDFormat>urn:oasis:names:tc:SAML:2.0:nameid-format:transient</NameIDFormat>
      <SingleSignOnService
          Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"
          Location="https://localhost/feide/idp/sso_service"/>
    </IDPSSODescriptor>
  </EntityDescriptor>
</EntitiesDescriptor>
EOT
