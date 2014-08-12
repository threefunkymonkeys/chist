require 'json'

module ChistApp
  class Chists < Cuba
    define do
      on put do
        on ":id/favorite" do |id|
          chist = Chist[id]
          not_found! unless chist && chist.user_id == current_user.id

          current_user.toggle_favorite(chist)

          if req.xhr?
            res.write(
              {:id => chist.id, :favorite => current_user.favorited?(chist)}.to_json
            )
          else
            res.redirect("/chists/#{chist.id}")
          end

        end

        on ':id' do |chist_id|
          on authenticated(User) do
            chist = Chist[chist_id]
            if chist && chist.user_id == current_user.id
              begin
                chist_params = req.params['chist']
                chist_form = ChistApp::Validators::ChistForm.hatch(chist_params)

                raise ArgumentError.new(chist_form.errors.full_messages.join(', ')) unless chist_form.valid?

                chist.title = chist_params['title']
                chist.chist_raw = chist_params['chist'].dup
                chist.chist = ChistApp::Parser.parse(chist_params['format'], chist_params['chist'])
                chist.public = chist_params.has_key?('public')
                chist.format = chist_params['format']
                chist.save
                flash[:success] = I18n.t('chists.chist_edited')
                res.redirect "/chists/#{chist.id}"
              rescue => e
                flash[:error] = e.message
                chist_params.delete('chist')
                session['chist.chist_params'] = chist_params
                res.redirect "/chists/#{chist.id}/edit"
              end
            else
              not_found!
            end
          end

          not_found!
        end
      end

      on post do
        on root do
          begin
            chist = req.params['chist'].strip
            chist_form = ChistApp::Validators::ChistForm.hatch(chist)

            raise ArgumentError.new(chist_form.errors.full_messages.join(', ')) unless chist_form.valid?

            Chist.create({
              title:     chist['title'],
              chist_raw: chist['chist'].dup,
              chist:     ChistApp::Parser.parse(chist['format'], chist['chist']),
              public:    chist.has_key?('public'),
              format:    chist['format'],
              user:      current_user
            })

            flash[:success] = I18n.t('chists.chists_created')
            res.redirect '/dashboard'
          rescue => e
            flash[:error] = e.message
            chist.delete('chist')
            session['chist.chist_params'] = chist
            res.redirect '/chists/new'
          end
        end

        not_found!
      end

      on get do
        on 'new' do
          on authenticated(User) do
            res.write render("./views/layouts/app.haml") {
              render("./views/chists/new.haml", chists: current_user.latest_chists, params: session.delete('chist.chist_params') || {})
            }
          end

          not_found!
        end

        on ':id/edit' do |chist_id|
          on authenticated(User) do
            chist = Chist[chist_id]

            #nasty trick for correct display in text area
            chist.chist_raw = chist.chist_raw.gsub("\r\n", "\r")

            if chist && chist.user_id == current_user.id
              res.write render("./views/layouts/app.haml") {
                render("./views/chists/edit.haml", chist: chist, params: session.delete('chist.chist_params') || {})
              }
            else
              not_found!
            end
          end

          not_found!
        end

        on ":id" do |chist_id|
          if chist = Chist[chist_id]
            res.write render("./views/layouts/app.haml", is_public: chist.public) {
              render("./views/chists/show.haml", chist: chist)
            }
          else
            not_found!
          end
        end

        not_found!
      end


      on delete do
        on ':chist_id' do |chist_id|
          if chist = Chist[chist_id]
            chist.destroy
            flash[:success] = I18n.t('chists.deleted')
            res.redirect '/dashboard'
          else
            not_found!
          end
        end

        not_found!
      end

      not_found!
    end
  end
end

