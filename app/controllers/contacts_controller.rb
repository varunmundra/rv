class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    
    # @contact.request = request
    
    if @contact.save
      ContactMailer.welcome_email(@contact).deliver
      flash.now[:notice] = 'Thank you for your message. We will contact you soon!'      
    else
      flash.now[:error] = 'Cannot send message.'
      render :new
    end
  
  end

  def welcome_email
   
  end
end



