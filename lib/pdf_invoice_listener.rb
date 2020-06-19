class InvoiceHookListener < Redmine::Hook::ViewListener
  def view_issues_context_menu_start(context = {})
    return "<li>" + link_to(h(l(:generate_invoice)), Rails.application.routes.url_helpers.bulk_edit_issues_path(:ids => context[:issues]), {:class => 'icon icon-edit'}) + "</li>"
  end
end
