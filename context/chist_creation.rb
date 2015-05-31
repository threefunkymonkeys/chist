module ChistApp::Context
  class ChistCreation
    attr_reader :chist, :error_message

    def initialize(chist_params, ctx)
      @chist_params = chist_params
      @ctx = ctx
    end

    def call
      begin
        chist_form = ChistApp::Validators::ChistForm.hatch(@chist_params)

        raise ArgumentError.new(chist_form.errors.full_messages.join(', ')) unless chist_form.valid?

        @chist = Chist.create({
          title:     @chist_params['title'],
          chist_raw: @chist_params['chist'].dup,
          chist:     ChistApp::Parser.parse(@chist_params['format'], @chist_params['chist']),
          public:    @chist_params['public'].to_i == 1,
          format:    @chist_params['format'],
          user:      @ctx.current_user
        })

        :success
      rescue => e
        @error_message = e.message
        :error
      end
    end
  end
end
