module ChistApp::Context
  class ChistUpdate
    attr_reader :chist, :error_message

    def initialize(chist, params, ctx)
      @chist        = chist
      @chist_params = params
      @ctx          = ctx
    end

    def call
      begin
        chist_form = ChistApp::Validators::ChistForm.hatch(@chist_params)

        raise ArgumentError.new(chist_form.errors.full_messages.join(', ')) unless chist_form.valid?

        @chist.title = @chist_params['title']
        @chist.chist_raw = @chist_params['chist'].dup
        @chist.chist = ChistApp::Parser.parse(@chist_params['format'], @chist_params['chist'])
        @chist.public = @chist_params['public']
        @chist.format = @chist_params['format']
        @chist.save

        :success
      rescue => e
        @error_message = e.message
        :error
      end
    end
  end
end
