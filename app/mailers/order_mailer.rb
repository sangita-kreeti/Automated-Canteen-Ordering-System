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

  def add_order_details(pdf, orders)
    orders.each do |order|
      add_order(pdf, order)
      add_separator(pdf)
    end
  end

  def add_order(pdf, order)
    pdf.move_down 20
    pdf.text "Food Store: #{order.food_store_name}", color: '000000', size: 20
    pdf.move_down 10
    pdf.text "Food Items: #{order.food_item_names.join(', ')}"
    pdf.text "Quantities: #{order.quantities.join(', ')}"
    pdf.text "Prices: #{order.prices.join(', ')}"
  end

  def add_separator(pdf)
    pdf.move_down 20
    pdf.stroke_color '009900'
    pdf.stroke_horizontal_rule
    pdf.stroke_color '000000'
  end

  def add_total_price(pdf, total_price)
    pdf.move_down 20
    pdf.text "Total Price: #{total_price}", color: 'FF0000', size: 22, style: :bold, align: :center
  end
end
