class ContactMailer < ActionMailer::Base
  default from: "info@rupeevest.com"


  def contact_confirmation(contact)
    @contact = contact
    mail(:to => "#{contact.name} <#{contact.email}>", :subject => "Rupeevest Query")
  end

end


