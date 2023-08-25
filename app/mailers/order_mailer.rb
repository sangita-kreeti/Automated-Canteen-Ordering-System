
class OrderMailer < ApplicationMailer
  def order_confirmation_email(orders, total_price)
    @orders = orders
    @total_price = total_price
    pdf_content = generate_consolidated_pdf(@orders, @total_price)

    attachments['consolidated_order_details.pdf'] = pdf_content

    mail(to: @orders.first.user.email, subject: 'Order Confirmation')
  end

  private

  def generate_consolidated_pdf(orders, total_price)
    pdf = Prawn::Document.new
    pdf.text 'Consolidated Order Details'

    orders.each do |order|
      pdf.text "Food Store: #{order.food_store_name}" # Use food_store_name here
      pdf.text "Food Items: #{order.food_item_names.join(', ')}"
      pdf.text "Quantities: #{order.quantities.join(', ')}"
      pdf.text "Prices: #{order.prices.join(', ')}"
      pdf.text '-' * 40
    end

    pdf.text "Total Price: #{total_price}"

    pdf.render
  end
end
