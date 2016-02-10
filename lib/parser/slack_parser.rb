class ChistApp::SlackParser

  def self.parse(log)
    time_regexp = /^.*\s*\[\d+:\d{2}\s*[AMP]{2}*\]\s*/

    #scan for participants
    participants = log.each_line.grep(/.+\s\[\d{1,2}:\d{1,2}\s*[AMP]{0,2}\].+/).collect{ |capture| capture.split(" [").first }.uniq

    #map classes for participants
    classes = Hash.new
    participants.each_with_index { |username, key| classes[username] = "<span class=\"username_#{key}\">#{username}</span>"}

    output = ""
    username = ""
    force_exit = false

    log.each_line do |line|
      time = line.scan(time_regexp)

      if time.any?
        parsed = time.first.scan(/(^.+)?(\s*\[\d+:\d{2}\s*[AMP]{2}*\])/).first

        #Nasty trick to deal with invisible character inserted by scan
        if parsed.first.to_s.strip.length > 1
          @last_nickname = parsed.first.strip
          @last_timestamp = parsed.last.strip
        else
          parsed.last.gsub!(/\[|\]/,"")
          @last_timestamp.gsub!(/\d+:\d+/, parsed.last)
        end

        username = "#{@last_timestamp} #{@last_nickname}"
        next
      end

      if line.strip.empty?
        username = ""
        next
      end

      if username.empty?
        message = line
      else
        message = "#{username}: #{line}"
      end

      #apply class to usernames
      classes.each do |k,v|
        message.gsub! /#{Regexp.escape(k)}/, v
      end

      #identify links
      message.gsub! /(https?:\/\/[^\s]*)/, '<a href="\1" target="_blank">\1</a>'

      #construct chat line into div
      if username.empty?
        output += "<div class=\"system-message line\"><span class=\"message\">#{message.strip}</span></div>\r\n"
      else
        output += "<div class=\"line\"><span class=\"message\">#{message.strip}</span></div>\r\n"
      end
    end

    output
  end
end
