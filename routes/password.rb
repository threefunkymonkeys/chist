class ChistApp::Password < Cuba
  define do
    on authenticated(User) do
      on get, 'reset' do
        res.write render("./views/layouts/app.haml") {
          render("./views/users/password_reset.haml", { :token => current_user.token_reset })
        }
      end

      on put, 'reset' do
        begin
          raise StandardError.new(I18n.t("user.password_doesnt_match")) unless req.params['new_password'] == req.params['confirm_password']
          current_user.password = req.params['new_password']
          current_user.update_password = false
          current_user.save
          flash[:success] = I18n.t('user.password_changed')
          redirect! '/'
        rescue StandardError => e
          flash[:error] = e.message
          redirect! '/password/reset'
        end
      end

      not_found!
    end

    not_found!
  end
end
