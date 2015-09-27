module ChistApp::Context
  class ContactForm
    attr_reader :contact, :error_message

    def initialize(params, ctx)
      @params = params
      @ctx = ctx
    end

    def call
      begin
        contact_form = ChistApp::Validators::ContactForm.hatch(@params)

        raise ArgumentError.new(contact_form.errors.full_messages.join(', ')) unless contact_form.valid?

        @contact = Contact.create({
          name:     @params['name'],
          email:     @params['email'],
          message:     @params['message'],
          sample:     @params['sample'],
          created_at: DateTime.now
        })

        :success
      rescue => e
        @error_message = e.message
        :error
      end
    end
  end
end

