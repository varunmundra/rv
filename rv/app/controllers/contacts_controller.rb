class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    
    # @contact.request = request
    
    if @contact.save
      ContactMailer.contact_confirmation(@contact).deliver
      flash.now[:notice] = 'Thank you for your message. We will contact you soon!' 
      redirect_to :controller=>'static_pages', :action => 'index'     
    else
      flash.now[:error] = 'Cannot send message.'
      render :new
    end
  
  end

  private
    def contact_params
      params.require(:contact).permit(:name,:email, :phone, :message)
      

    end



 
end



