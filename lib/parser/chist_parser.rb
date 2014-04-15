require_relative './irc_parser'
require_relative './skype_parser'

class InvalidParserError < RuntimeError; end

class ChistApp::Parser
  def self.parse(type, text)
    case(type)
    when :irc, "irc"
      ChistApp::IRCParser.parse(text)
    when :skype, "skype"
      ChistApp::SkypeParser.parse(text)
    when :none, "none"
      text
    else
      raise InvalidParserError.new
    end
  end
end
