class Cuba
  module Render::Helper
    def show_flash_message
      markup = []

      if flash.has_key?(:info)
        markup << "<div class='alert alert-dismissable alert-info'>
                     <button type='button' class='close' data-dismiss='alert'>×</button>
                     <p>#{flash[:info]}</p>
                   </div>"
        flash.delete(:info)
      end

      if flash.has_key?(:success)
        markup << "<div class='alert alert-dismissable alert-success'>
                     <button type='button' class='close' data-dismiss='alert'>×</button>
                     <p>#{flash[:success]}</p>
                   </div>"
        flash.delete(:success)
      end

      if flash.has_key?(:warning)
        markup << "<div class='alert alert-dismissable alert-warning'>
                     <button type='button' class='close' data-dismiss='alert'>×</button>
                     <p>#{flash[:warning]}</p>
                   </div>"
        flash.delete(:warning)
      end

      if flash.has_key?(:error)
        markup << "<div class='alert alert-dismissable alert-danger'>
                     <button type='button' class='close' data-dismiss='alert'>×</button>
                     <p>#{flash[:error]}</p>
                   </div>"
        flash.delete(:error)
      end

      markup.join("")
    end

    def chist_last_update(chist)
      last_update = chist.updated_at ? chist.updated_at : chist.created_at
      last_update.strftime('%Y-%m-%d %H:%M') if last_update
    end
  end
end
