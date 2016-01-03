require 'json'

module ChistApp
  class Chists < Cuba
    define do
      on CHIST_UUID do |uuid|
        chist = Chist[uuid]
        not_found! unless chist

        latest_chists = current_user ? current_user.latest_chists : []

        on get, root do
          res.write render("./views/layouts/app.haml", is_public: chist.public, chist: chist) {
            render("./views/chists/show.haml", chists: latest_chists, chist: chist)
          }
        end

        on get, 'raw' do
          res.write render("./views/chists/raw.haml", chist: chist.chist_raw.gsub('\r\n', '\r'))
        end

        on authenticated(User) do
          on put, "favorite" do
            current_user.toggle_favorite(chist)

            if req.xhr?
              res.write(
                {:id => chist.id, :favorite => current_user.favorited?(chist)}.to_json
              )
            else
              redirect! "/chists/#{chist.id}"
            end
          end

          on chist_owner?(chist) do
            on get, 'edit' do |chist_id|

              #nasty trick for correct display in text area
              chist.chist_raw = chist.chist_raw.gsub("\r\n", "\r")

              res.write render("./views/layouts/app.haml") {
                render("./views/chists/edit.haml", chists: current_user.latest_chists, chist: chist, params: session.delete('chist.chist_params') || {})
              }
            end

            on put, root do
              ctx = ChistApp::Context::ChistUpdate.new(chist,
                                                       req.params["chist"],
                                                       self)
              case ctx.call
              when :success
                flash[:success] = I18n.t('chists.chist_edited')
                redirect! ctx.chist.url
              when :error
                flash[:error] = ctx.error_message
                req.params['chist'].delete('chist')
                session['chist.chist_params'] = req.params['chist']
                redirect! "/chists/#{chist.id}/edit"
              end
            end

            on delete, root do
              chist.destroy_cascade
              flash[:success] = I18n.t('chists.deleted')
              redirect! '/dashboard'
            end

            not_found!
          end

          not_found!
        end

        not_found!
      end

      on authenticated(User) do
        on get, "new" do
          res.write render("./views/layouts/app.haml") {
            render("./views/chists/new.haml", chists: current_user.latest_chists, params: session.delete('chist.chist_params') || {})
          }
        end

        on post, root do
          chist_params = req.params['chist'].strip
          ctx = ChistApp::Context::ChistCreation.new(chist_params, self)
          case ctx.call
          when :success
            flash[:success] = I18n.t('chists.chists_created')
            redirect! "/chists/#{ctx.chist.id}"
          when :error
            flash[:error] = ctx.error_message
            session['chist.chist_params'] = chist_params
            redirect! '/chists/new'
          end
        end

        not_found!
      end

      not_found!
    end
  end
end
