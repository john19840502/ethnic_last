Spree::Admin::OrdersController.class_eval do

  def invoice
    load_order

  	Spree::OrderMailer.send_invoice(@order.id, true).deliver_later
    flash[:success] = Spree.t(:order_email_resent)

    redirect_to :back
  end

  def show
    load_order
    Spree::OrderMailer.send_invoice(@order.id, true, @order.pdf_file(pdf_template_name)).deliver_later
    respond_with(@order) do |format|
      format.pdf do
        @order.update_invoice_number!

        send_data @order.pdf_file(pdf_template_name),
          type: 'application/pdf', disposition: 'inline'
      end
    end

  end

  # def index
  #   debugger
  #   api_key = Spree::PaymentMethod::Mollie.first.get_preference(:api_key)
  #   client = Mollie::Client.new(api_key)
                    
  #   params[:q] ||= {}
  #   params[:q][:completed_at_not_null] ||= '1' if Spree::Config[:show_only_complete_orders_by_default]
  #   @show_only_completed = params[:q][:completed_at_not_null] == '1'
  #   params[:q][:s] ||= @show_only_completed ? 'completed_at desc' : 'created_at desc'
  #   params[:q][:completed_at_not_null] = '' unless @show_only_completed

  #   # As date params are deleted if @show_only_completed, store
  #   # the original date so we can restore them into the params
  #   # after the search
  #   created_at_gt = params[:q][:created_at_gt]
  #   created_at_lt = params[:q][:created_at_lt]

  #   params[:q].delete(:inventory_units_shipment_id_null) if params[:q][:inventory_units_shipment_id_null] == "0"

  #   if params[:q][:created_at_gt].present?
  #     params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue ""
  #   end

  #   if params[:q][:created_at_lt].present?
  #     params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
  #   end

  #   if @show_only_completed
  #     params[:q][:completed_at_gt] = params[:q].delete(:created_at_gt)
  #     params[:q][:completed_at_lt] = params[:q].delete(:created_at_lt)
  #   end

  #   @search = Order.accessible_by(current_ability, :index).ransack(params[:q])

  #   # lazyoading other models here (via includes) may result in an invalid query
  #   # e.g. SELECT  DISTINCT DISTINCT "spree_orders".id, "spree_orders"."created_at" AS alias_0 FROM "spree_orders"
  #   # see https://github.com/spree/spree/pull/3919
  #   @orders = @search.result(distinct: true).
  #     page(params[:page]).
  #     per(params[:per_page] || Spree::Config[:orders_per_page])

  #   # Restore dates
  #   params[:q][:created_at_gt] = created_at_gt
  #   params[:q][:created_at_lt] = created_at_lt
  # end


end