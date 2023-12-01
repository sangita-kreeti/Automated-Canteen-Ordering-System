# frozen_string_literal: true

# This is a controller
class OrderMailer < ApplicationMailer
  def order_confirmation_email(order)
    @order = order
    pdf_content = generate_pdf(@order)
    attachments['order_details.pdf'] = pdf_content
    mail(to: @order.user.email, subject: 'Order Confirmation')
  end

  def generate_pdf(order)
    pdf = Prawn::Document.new
    add_header(pdf)
    add_order_details(pdf, order)
    pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 100], width: pdf.bounds.width,
                                                              height: pdf.bounds.height - 200) do
    end
    pdf.render
  end

  private

  def add_header(pdf)
    pdf.text 'Order Details', color: '009900', style: :bold, size: 24, align: :center
    pdf.move_down 20
  end

  def add_order_details(pdf, order)
    add_order(pdf, order)
    add_separator(pdf)
  end

  def add_order(pdf, order)
    pdf.move_down 20
    pdf.text "Food Store: #{order.food_store_name}", color: '000000', size: 20
    pdf.move_down 10
    pdf.text "Food Item: #{order.food_item_name}"
    pdf.text "Quantity: #{order.quantity}"
    pdf.text "Price: #{order.price}"
  end

  def add_separator(pdf)
    pdf.move_down 20
    pdf.stroke_color '009900'
    pdf.stroke_horizontal_rule
    pdf.stroke_color '000000'
  end
end
