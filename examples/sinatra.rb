require 'sinatra'
require 'saml'
require 'feide'

##### CONFIGURATION
#

# This need to be set to the same port as the one feide expects to
# connect to.
# 
# (If this happens to be a privileged port and you use RVM, use
# rvmsudo to start the app.)
set :port, 80 

# Location of the SAML Metadata document containing an
# <EntitiesDescriptor> as the root element with both your and feides
# <EntityDescriptor>s.
metadata = 'feide.xml'

#
##### END: CONFIGURATION

meta = SAML::Metadata::EntitiesDescriptor.from_xml(SAML::Metadata::Document.new(open(metadata, 'r')).root)

use Feide::RackServiceProvider, { :meta => meta }

get '/' do
  <<EOT
<h1>The Sinatra Example</h1>
<ul>
  <li><a href="/feide/signon?relay_state=foo">Signon</a>
  <li><a href="/feide/logout?user=test@feide.no&relay_state=bar">Logout</a>
EOT
end

post meta.sp_assertion_consumer_service.location.path do
  r = env['X-SAMLResponse'].core_response
  rs = env['X-SAMLResponse'].relay_state
  str = "<pre>Status success?: #{r.success?}\n"
  str << "RelayState: #{rs}\n"
  str << "Subject:    #{r.assertions.first.subject.name_id}\n"
  str << "AuthnStatement:\n"
  an = r.assertions.first.authn_statements.first
  str << "         AuthnInstant: #{an.authn_instant}\n"
  str << "  SessionNotOnOrAfter: #{an.session_not_on_or_after}\n"
  str << "         SessionIndex: #{an.session_index}\n"
  str << "Attributes\n"
  r.assertions.first.attribute_statement.attributes.each do |a|
    str << "  #{a.name} #{a.attribute_values}\n"
  end
  str
end
  
get meta.sp_single_logout_service.location.path do
  r = env['X-SAMLResponse'].core_response
  rs = env['X-SAMLResponse'].relay_state
  str = "<pre>Status success?: #{r.success?}\n"
  str << "RelayState: #{rs}\n"
  str
end
