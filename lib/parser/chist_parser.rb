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
    when :limechat, "limechat"
      ChistApp::Limechat.parse(text)
    when :colloquy, "colloquy"
      ChistApp::Limechat.parse(text)
    when :limechatsample, "limechatsample"
      ChistApp::Limechat::Sample.parse(text)
    when :slack, "slack"
      ChistApp::SlackParser.parse(text)
    when :none, "none"
      text
    else
      raise InvalidParserError.new
    end
  end
end
