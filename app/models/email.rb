class Email < ApplicationRecord
  def filter(objects, name)
    @profiles.each_with_object({}) do |profile, names|
      names[profile[:user_id]] = profile[:full_name]
    end
  end

  def self.process
    gmail_service = GmailService.create_service
    user_id = 'me'    # my gmail account
    q = 'is:unread'   # query for unread message
    unread_messsages = gmail_service.list_user_messages(user_id, {q: q} ).messages
    if !unread_messsages
      return { Message: "No exist unread message!!!" }
    end

    result = []
    unread_messsages.each do |unread_message|
      unread_email = gmail_service.get_user_message(user_id, unread_message.id)
      result.push({
        from: unread_email.payload.headers[16],
        subject: unread_email.payload.headers[19],
        attachment: unread_email.payload.parts.select{ |obj| obj.filename.match(/.pdf$/) }
      })
    end
    result
  end
end