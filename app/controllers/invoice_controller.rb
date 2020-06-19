class InvoiceController < ApplicationController
  unloadable

  #before_filter :find_project
  before_filter :authorize

  def invoice
    issues = params[:ids]

    respond_to do |format|
        format.pdf do
            @issues = Issue.where(id: params[:ids]).order("created_on DESC")
            send_file_headers! :type => 'application/pdf', :filename => 'issues.pdf'
        end

  rescue ActiveRecord::RecordNotFound
    render_404
  end

  private
end
