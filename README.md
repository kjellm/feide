[![Build Status](https://secure.travis-ci.org/kjellm/feide.png?branch=master)](http://travis-ci.org/kjellm/feide)

FEIDE
=====

Library that aids in making a SAML Service Provider for the FEIDE SAML Identity Provider.

The main part of this library is a Rack middelware, making it easy to
integrate with Rails, Sinatra, or any other Rack based frameworks.

Install
-------

    gem install feide

Usage
-----

See examples/sinatra.rb

For the example to work you need a XML file containing proper SAML
metadata. You need to get this metadata directly from FEIDE. The
examples/feide_template.xml file shows what the metadata should look
like.

Documents describing FEIDE
--------------------------

- http://www.feide.no/sites/feide.no/files/documents/Feide_technical_guide.pdf

- http://www.feide.no/attributelist
- https://rnd.feide.no/2009/07/09/saml_2_0_usage_in_feide/


Author
------

Kjell-Magne Øierud (kjellm AT oierud DOT net)
	
Bugs
----

Report bugs to http://github.com/kjellm/feide/issues
	
License
-------

(The MIT License)

Copyright © 2012 Gyldendal ASA

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the ‘Software’), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
