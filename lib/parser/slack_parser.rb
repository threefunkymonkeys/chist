class ChistApp::SlackParser

  def self.parse(log)
    time_regexp = /^.+\s\[\d+:\d{2}\s[AMP]{2}\]\s*/

    #scan for participants
    participants = log.scan(/(^.+\s\[\d+:\d{2}\s[AMP]{2}\])\s*$/).collect! {|scan| scan.first.split(" ").first }.uniq

    #map classes for participants
    classes = Hash.new
    participants.each_with_index { |username, key| classes[username] = "<span class=\"username_#{key}\">#{username}</span>"}

    output = ""
    username = ""
    force_exit = false

    log.each_line do |line|
      time = line.scan(time_regexp)

      if time.any?
        parsed = time.first.scan(/(^\w+)(\s\[\d+:\d{2}\s[AMP]{2}\])/).first
        username = "#{parsed.last.strip} #{parsed.first.strip}"
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
