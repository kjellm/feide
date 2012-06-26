require 'spec_helper.rb'

module Feide
  describe RackServiceProvider do

    describe '#call' do

      context 'Recognized requests' do
          
        def handle_request(env, handler_method)
          app = double('Rack::App')
          app.should_not_receive('call')
          
          handler_class = double('SAMLHandlerClass')
          handler = double('SAMLHandler')
          handler_class.should_receive(:new).and_return(handler)
          handler.should_receive(handler_method).and_return(true)
          
          sp = RackServiceProvider.new(app, { :meta => META, :handler_class => handler_class })
          sp.call(env)
        end
        
        it "should handle GET /feide/signon" do
          env = {
            'REQUEST_METHOD' => 'GET',
            'PATH_INFO' => '/feide/signon'
          }
          handle_request(env, :signon)
        end
        
        it "should handle GET /feide/logout" do
          env = {
            'REQUEST_METHOD' => 'GET',
            'PATH_INFO' => '/feide/logout'
          }
          handle_request(env, :consume_logout)
        end

      end

      context 'Urecognized requests' do

        subject do
          app = double('Rack::App')
          app.should_receive('call')
          RackServiceProvider.new(app, { :meta => META })
        end
        
        it "should just pass on POST /foo" do
          env = {
            'REQUEST_METHOD' => 'POST',
            'PATH_INFO' => '/foo'
          }
          subject.call(env)
        end
        
        it "should just pass on GET /bar" do
          env = {
            'REQUEST_METHOD' => 'GET',
            'PATH_INFO' => '/bar'
          }
          subject.call(env)
        end

      end
    end

  end
end
