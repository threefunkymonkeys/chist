class ChistApp::Limechat
  COMMANDS = ['Mode', 'Created at', '***']

  def self.parse(log)
    output = ""
    members = []
    classes = {}
    log.split(/\n\r?/).each do |line|
      if match = /^\[?\d{1,2}:\d{2}(am|pm)?\]?\s([^\s]+)\shas\s(join|left)+/.match(line)
        members << match[2] and members.uniq!
        output += "<div class=\"line\">" + line.gsub(/^(.+)$/, '<span class="channel-info">\1</span>') + "</div>\r\n"
      elsif match = /^(\[?\d{1,2}:\d{2}(am|pm)?\]?)\s([^:]+):(.+)/.match(line)
        if COMMANDS.include? match[3]
          output += "<div class=\"line\">" + line.gsub(/^(.+)$/, '<span class="channel-info">\1</span>') + "</div>\r\n"
        else
          members << match[3] and members.uniq!
          output += "<div class=\"line\">#{match[1]} #{match[3]}: <span class=\"message\">#{match[4]}</span></div>\r\n"
        end
      else
        output += "<div class=\"line\">" + line.gsub(/^(.+)$/, '<span class="channel-info">\1</span>') + "</div>\r\n"
      end
    end
    members.each_with_index { |username, key| classes[username] = "<span class=\"username_#{key}\">#{username}</span>"}

    classes.each do |k,v|
      output.gsub! /#{k}/, v
    end
    output.gsub! /(https?:\/\/[^\s\n]*)/, '<a href="\1" target="_blank">\1</a>'

    output
  end
end
