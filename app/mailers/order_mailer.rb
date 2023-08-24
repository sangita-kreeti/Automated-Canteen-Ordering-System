# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  require 'prawn'

  def confirmation_email(order_group)
    @order_group = order_group
    pdf_attachment = generate_order_pdf(order_group)
    attachments['Invoice.pdf'] = pdf_attachment
    mail(to: order_group.first.user.email, subject: 'Order Placed Successfully')
  end

  private

  def generate_order_pdf(order_group)
    Prawn::Document.new.tap do |pdf|
      pdf.text 'Order Details', size: 24, style: :bold, color: '0000FF', align: :center
      pdf.move_down 10
  
      order_group.each do |order|
        pdf.move_down 10
        pdf.text "Food Item: #{order.food_item_names.join(', ')}", color: '0000FF', align: :center
        pdf.text "Quantity: #{order.quantities.join(', ')}", color: '800080', align: :center
        pdf.text "Food Store Name: #{order.food_store_name}", color: '800080', align: :center
        pdf.text "Price: #{order.prices.map { |price| "$#{price}" }.join(', ')}", color: 'A52A2A', align: :center
      end
    end.render
  end
end
