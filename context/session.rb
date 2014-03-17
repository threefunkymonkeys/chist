module ChistApp::Context
  module Session
    def current_user
      authenticated(User)
    end

    def flash
      session['chist.flash'] = (@env['rack.session']['chist.flash'] || {})
      session['chist.flash']
    end
  end
end
