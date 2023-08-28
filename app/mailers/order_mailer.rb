# frozen_string_literal: true

# This is a controller
class OrderMailer < ApplicationMailer
  def order_confirmation_email(orders, total_price)
    @orders = orders
    @total_price = total_price
    pdf_content = generate_pdf(@orders, @total_price)

    attachments['order_details.pdf'] = pdf_content

    mail(to: @orders.first.user.email, subject: 'Order Confirmation')
  end

  def generate_pdf(orders, total_price)
    pdf = Prawn::Document.new
    add_header(pdf)
    add_order_details(pdf, orders)
    add_total_price(pdf, total_price)
    pdf.render
  end

  private

  def add_header(pdf)
    pdf.text 'Consolidated Order Details'
  end

  def add_order_details(pdf, orders)
    orders.each do |order|
      add_order(pdf, order)
      add_separator(pdf)
    end
  end

  def add_order(pdf, order)
    pdf.text "Food Store: #{order.food_store_name}"
    pdf.text "Food Items: #{order.food_item_names.join(', ')}"
    pdf.text "Quantities: #{order.quantities.join(', ')}"
    pdf.text "Prices: #{order.prices.join(', ')}"
  end

  def add_separator(pdf)
    pdf.text '-' * 40
  end

  def add_total_price(pdf, total_price)
    pdf.text "Total Price: #{total_price}"
  end
end
