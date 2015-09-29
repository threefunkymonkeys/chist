class ChistApp::SkypeParser

  def self.parse(log)
    time_regexp = /^\[[^\]]+\]/
    #scan for participants
    participants = log.scan(/\[.*\d+:\d{2}:\d{2}\s[AMPM]{2}\]\s([^:]+):.+/).uniq.collect! { |scan| scan.last }
    #map classes for participants
    classes = Hash.new
    participants.each_with_index { |username, key| classes[username] = "<span class=\"username_#{key}\">#{username}</span>"}

    output = ""
    log.each_line do |line|
      #get time and clean chat line
      time = line.scan(time_regexp)
      message = line.gsub time_regexp, ''

      #apply class to usernames
      classes.each do |k,v|
        message.gsub! /#{Regexp.escape(k)}/, v
      end

      #identify links
      message.gsub! /(https?:\/\/[^\s]*)/, '<a href="\1" target="_blank">\1</a>'

      #construct chat line into div
      output += "<div class=\"line\"><span class=\"time\">#{time.first || ''}</span><span class=\"message\">#{message.strip}</span></div>\r\n"
    end

    output
  end
end
