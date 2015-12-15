class ChistApp::Contact < Cuba
  define do
    on get, root do
      res.write render("./views/layouts/app.haml") {
        render("./views/public/contact.haml", params: session.delete('contact.params') || {});
      }
    end

    on post, root do
      params = req.params['contact'].strip
      ctx = ChistApp::Context::ContactForm.new(params, self)
      case ctx.call
      when :success
        flash[:success] = I18n.t('contact.sent')
      when :error
        flash[:error] = ctx.error_message
        session['contact.params'] = params
      end
      redirect! "/contact"
    end
  end
end
