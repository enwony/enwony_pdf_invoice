class InvoiceHookListener < Redmine::Hook::ViewListener
  def view_issues_context_menu_start(context = {})
    return "<li>" + link_to(h(l(:generate_invoice)), url_for(controller: 'invoice', action: 'invoice', format: 'pdf', ids: context[:issues]), {:class => 'icon'}) + "</li>"
  end
end
