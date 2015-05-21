Spree::FrontendHelper.class_eval do
  def checkout_states
    @order.reload.checkout_steps
  end

  def state_required_class
    'required' if state_required?
  end

  def state_required_label
    if state_required?
      content_tag :span, '*', class: state_required_class
    end
  end

  def checkout_progress
    states = checkout_states
    items = states.map do |state|
      next if state == 'payment'
      text = t("order_state.#{state}").titleize
      css_classes = []
      if @order.state == 'delivery_quote'
        current_index = 2
      else
        current_index = states.index(@order.state)
      end
      state_index = states.index(state)
      if state_index < current_index
        css_classes << 'completed'
        text = link_to text, checkout_state_path(state)
      else
        text = link_to text, '#'
      end
      css_classes << 'next' if state_index == current_index + 1
      css_classes << 'selected' if state == @order.state
      css_classes << 'first' if state_index == 0
      css_classes << 'last' if state_index == states.length - 1
      content_tag('li', text, :class => css_classes.join(' '))
    end
    content_tag('ul', raw(items.join("\n")), class: 'steps', id: "checkout-step-#{@order.state}")
  end

  private
  def state_required?
    Spree::Config[:address_requires_state]
  end
end
