Redmine::Plugin.register :enwony_pdf_invoice do
  name 'Enwony PDF invoice plugin'
  author 'Enwony enwony@gmail.com'
  description 'Allow to generate pdf invoice for seleted issues in issue list view'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  require_dependency File.expand_path('../lib/invoice_hook_listener', __FILE__)
end
