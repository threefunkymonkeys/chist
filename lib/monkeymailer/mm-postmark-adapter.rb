require 'postmark'

module MonkeyMailer
 module Adapters
   class Postmark

     attr_reader :key

     def initialize(options)
       @key = options.fetch(:postmark_api_token)
     end

     def send_email(email)
       client = ::Postmark::ApiClient.new(key)

       postmark_message = {
         :from => "#{email.from_name} <#{email.from_email}>",
         :to => "#{email.to_name} <#{email.to_email}>",
         :subject => email.subject,
         :html_body => email.body,
         :text_body => email.body.to_s.gsub(/<\/?[^>]*>/, ""),
         :track_opens => true
       }

       response = client.deliver(postmark_message)

       unless response[:message] == "OK"
        raise MonkeyMailer::DeliverError.new(
          "Postmark delivery failed with error #{response[:error_code]}"
        )
       end

       puts "Response #{response[:message]} #{response[:message_id]}"
     end
   end
 end
end
