require File.expand_path('../../../../../../lib/redmine/wiki_formatting/textile/redcloth3', __FILE__)
require 'prawn/qrcode/table'

prawn_document(filename: @title + ".pdf", page_layout: :landscape, page_size: "A4", margin: 30) do |pdf|
  base = Redmine::Plugin.find('enwony_pdf_invoice').directory + '/dejavu/'
  pdf.font_families.update("Arial" => {
    :normal => base + 'DejaVuSans.ttf',
    :bold => base + 'DejaVuSans-Bold.ttf'
  })

  total_spent = @issues.inject(0) {|sum, i| sum + i.spent_hours.to_f }
  total_sum = @issues.inject(0) {|sum, i| sum + i.custom_field_value(5).to_i }

  bank_inn = "7710140679"
  bank_bik = "044525974"
  bank_name = "АО \"ТИНЬКОФФ БАНК\""
  bank_acc = "30101810145250000974"
  ip_acc = "40802810800005815286"
  ip_name = "ИП МИЩЕНКО НИКОЛАЙ ВИКТОРОВИЧ"
  ip_inn = "650623394898"
  personal_name = "Мищенко Николай Викторович"
  personal_tel = "+7 902 505 0058"
  personal_card = "4276 5000 2432 3535"
  sum_full = total_sum * 100

  purpose = "Оплата по счету от " + @datestr

  params = ["ST00012", "Name=" + ip_name, "PersonalAcc=" + ip_acc, "BankName=" + bank_name, "BIC=" + bank_bik, "CorrespAcc=" + bank_acc, "PayeeINN=" + ip_inn, "Sum=#{sum_full}", "Purpose=" + purpose]
  qrcode = params.join("|")

  pdf.font "Arial"
  pdf.text @title, :size => 14, :style => :bold
  pdf.move_down 10

  pdf.text l("total", sum: total_sum, hours: total_spent), :size => 10, :inline_format => true
  pdf.move_down 8

  pay_visa = "Номер карты: *#{personal_card}*\nТелефон: #{personal_tel}\nФИО: #{personal_name}\nСумма: %d" % total_sum;
  pay_invoice = "Банк: #{bank_name}\nИНН банка #{bank_inn}: \nБИК #{bank_bik}: \nКорреспондентский счет: #{bank_acc}\nРасчетный счет *#{ip_acc}*\n\nПолучатель: #{ip_name}\nИНН: *#{ip_inn}*\nСумма: %d" % total_sum;

  x = RedCloth3.new(pay_visa)
  x.lite_mode = true
  pay_visa = x.to_html()

  x = RedCloth3.new(pay_invoice)
  x.lite_mode = true
  pay_invoice = x.to_html()

  qr = pdf.make_qrcode_cell(content: qrcode, dot: 2, stroke: false)
  pdf.table([["Оплата на карту VISA", "Оплата на счет", "Оплата по QR"], [pay_visa, pay_invoice, qr]], :column_widths => [250, nil, 155]) do
    row(0).font_style = :bold
    cells.background_color = "F0FFF0"
    row(0).background_color = "40B040"
    row(1).inline_format = true
  end
  pdf.move_down 8

  pdf.text l("contact"), :size => 8, :inline_format => true
  pdf.move_down 8

  header = [ l("col_id"), l("col_start"), l("col_subject"), l("col_spent"), l("col_price"), l("col_desc") ]
  data = @issues.collect do |i| 
    formatter = RedCloth3.new(i.description)
    formatter.lite_mode = true
    text = formatter.to_html()
    [i.id, i.start_date.strftime('%F'), i.subject, i.spent_hours, i.custom_field_value(5), text]
  end

  pdf.table(data.unshift(header), :header => true, :column_widths => [28, 55, 80, 32, 32, nil]) do
    cells.background_color = "F0FFF0"
    cells.style(:size => 8)
    cells.padding = [5, 3, 5, 3]
    row(0).background_color = "40B040"
    row(0).font_style = :bold
    row(0).padding = 2
    row(0).height = 16
    columns(5).inline_format = true
    columns(0..2).align = :left
    columns(3..4).align = :right
    columns(5).align = :left
  end


end
