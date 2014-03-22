module ChistApp
  class Chists < Cuba
    define do
      on get do

        on ":id" do |chist_id|
          if chist = Chist[chist_id]
            res.write render("./views/layouts/app.haml") {
              render("./views/chists/show.haml", chist: chist)
            }
          else
            not_found!
          end
        end

        on authenticated(User) do
          on 'new' do
            res.write render("./views/layouts/app.haml") {
              render("./views/chists/new.haml", params: session.delete('chist.chist_params') || {})
            }
          end

          not_found!
        end

        not_found!
      end

      on post do
        on root do
          begin
            chist = req.params['chist'].strip
            chist_form = ChistApp::Validators::ChistForm.hatch(chist)

            raise ArgumentError.new(chist_form.errors.full_messages.join(', ')) unless chist_form.valid?

            Chist.create({
              title:     chist['title'],
              chist:     chist['chist'],
              chist_raw: chist['chist'],
              public:    chist.has_key?('public'),
              user: current_user
            })
            flash[:success] = I18n.t('chists.chists_created')
            res.redirect '/dashboard'
          rescue => e
            flash[:error] = e.message
            session['chist.chist_params'] = chist
            res.redirect '/chists/new'
          end
        end

        not_found!
      end

      not_found!
    end
  end
end

