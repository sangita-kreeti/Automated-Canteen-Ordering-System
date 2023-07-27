# frozen_string_literal: true

# This is a mailer
class OrderMailer < ApplicationMailer
  require 'prawn'

  def confirmation_email(order)
    @order = order
    pdf_attachment = generate_order_pdf(order)
    attachments['Invoice.pdf'] = pdf_attachment
    mail(to: @order.user.email, subject: 'Order Placed Successfully')
  end

  def generate_order_pdf(order)
    pdf = Prawn::Document.new

    pdf.text ':Order Details:', size: 24, style: :bold, color: '0000FF', align: :center
    pdf.move_down 10
    pdf.text "Food Item: #{order.food_item_names.join(', ')}", color: '0000FF', align: :center
    pdf.text "Quantity: #{order.quantities.join(', ')}", color: '800080', align: :center
    pdf.text "Food Store Name: #{order.food_store_names.join(', ')}", color: '800080', align: :center
    pdf.text "Price: #{order.prices.join(', ')}", color: 'A52A2A', align: :center

    pdf.render
  end
end
