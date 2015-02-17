Spree::Taxon.class_eval do

  scope :active, -> { where(enabled: true) }

  VISIBILITIES = {"1" => "Visible", "2" => "Only logged in clients", "3" => "Invisible"}

  def cart_partial(current_user)
    partial = "login_for_cart"
    if current_user || self.visibility.to_s == "1"
      partial = "cart_form"
    end
    partial
  end

  def invisible?
    VISIBILITIES[self.visibility.to_s] == "Invisible"
  end

  def invisible_for_not_logged_in?(current_spree_user)
    VISIBILITIES[self.visibility.to_s] == "Only logged in clients" && current_spree_user.nil?
  end
end

Spree::PermittedAttributes.taxon_attributes.push :visibility, :enabled
