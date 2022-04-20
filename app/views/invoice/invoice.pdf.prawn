require File.expand_path('../../../../../../lib/redmine/wiki_formatting/textile/redcloth3', __FILE__)

prawn_document(filename: @title + ".pdf", page_layout: :landscape, page_size: "A4", margin: 30) do |pdf|
  base = Redmine::Plugin.find('enwony_pdf_invoice').directory + '/dejavu/'
  pdf.font_families.update("Arial" => {
    :normal => base + 'DejaVuSans.ttf',
    :bold => base + 'DejaVuSans-Bold.ttf'
  })

  pdf.font "Arial"
  pdf.text @title, :size => 14, :style => :bold
  pdf.move_down 10

  total_spent = @issues.inject(0) {|sum, i| sum + i.spent_hours.to_f }
  total_sum = @issues.inject(0) {|sum, i| sum + i.custom_field_value(5).to_i }
  pdf.text l("total", sum: total_sum, hours: total_spent), :size => 10, :inline_format => true
  pdf.move_down 8

  pay_visa = "Номер карты: 4276 5000 2432 3535\nТелефон: +7 902 505 0058\nФИО: Николай Викторович М\nСумма: %d" % total_sum;
  pay_invoice = "Банк: ДАЛЬНЕВОСТОЧНЫЙ БАНК ПАО СБЕРБАНК\nБИК: 040813608\nНомер счета 40817810050001995394\nКорсчет: 30101810600000000608\nИмя: МИЩЕНКО НИКОЛАЙ ВИКТОРОВИЧ\nИНН ФЛ: 650623394898\nИНН банка: 7707083893\nКПП банка: 254002002\nСумма: %d" % total_sum;

  pdf.table([["Оплата на карту VISA", "Оплата на счет"], [pay_visa, pay_invoice]]) do
    row(0).font_style = :bold
    cells.background_color = "F0FFF0"
    row(0).background_color = "40B040"
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
