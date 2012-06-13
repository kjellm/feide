require 'sinatra'
require 'saml'
require 'feide_sp'

set :port, 80 # Protip: Use rvmsudo to start this app if you use rvm

xml = REXML::Document.new(open('feide.xml', 'r')).root

use FeideSP, { :meta => xml }

get '/' do
  'Hei'
end


