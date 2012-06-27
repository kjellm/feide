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
  <li><a href="/feide/signon">Signon</a>
  <li><a href="/feide/logout">Logout</a>
EOT
end

post meta.sp_assertion_consumer_service.location.path do
  str = "<pre>Status success?: #{env['X-SAMLResponse'].success?}\n"
  env['X-SAMLResponse'].assertions.first.attribute_statement.attributes.each do |a|
    str << "  #{a.name} #{a.attribute_values}\n"
  end
  str
end
  
get meta.sp_single_logout_service.location.path do
  "<pre>Status success?: #{env['X-SAMLResponse'].success?}\n</pre>"
end
