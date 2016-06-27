Spree::ContactUs::ContactsController.class_eval do
  def create
    @contact = Spree::ContactUs::Contact.new(params[:contact_us_contact])

    if @contact.save
      if Spree::ContactUs::Config.contact_tracking_message.present?
        flash[:contact_tracking] = Spree::ContactUs::Config.contact_tracking_message
      end
      redirect_to("/thank-you?email=#{@contact.email}", :notice => t('spree.contact_us.notices.success'))
    else
      render :new
    end
  end
end
