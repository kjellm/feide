require 'sinatra'
require 'saml'
require 'feide_sp'

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

meta = SAML::Metadata::Document.new(open(metadata, 'r')).root

use FeideSP, { :meta => meta }

get '/' do
  <<EOT
<h1>The Sinatra Example</h1>
<ul>
  <li><a href="/feide/signon">Signon</a>
  <li><a href="/feide/logout">Logout</a>
EOT
end


