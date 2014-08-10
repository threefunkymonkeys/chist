class Cuba
  module Render::Helper
    def show_flash_message
      markup = []

      if flash.has_key?(:info)
        markup << "<div class='alert alert-success'>#{flash[:info]}</div>"
        flash.delete(:info)
      end

      if flash.has_key?(:success)
        markup << "<div class='alert alert-success'>#{flash[:success]}</div>"
        flash.delete(:success)
      end

      if flash.has_key?(:warning)
        markup << "<div class='alert alert-success'>#{flash[:warning]}</div>"
        flash.delete(:warning)
      end

      if flash.has_key?(:error)
        markup << "<div class='alert alert-success'>#{flash[:error]}</div>"
        flash.delete(:error)
      end

      markup.join("<br/>")
    end

    def chist_last_update(chist)
      last_update = chist.updated_at ? chist.updated_at : chist.created_at
      last_update.strftime('%Y-%m-%d %H:%M') if last_update
    end
  end
end
