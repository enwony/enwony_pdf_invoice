require "prawn"

class InvoiceController < ApplicationController
  unloadable

#  before_filter :authorize

  def invoice
    issues = params[:ids]

    respond_to do |format|
        format.pdf do
            @issues = Issue.where(id: params[:ids]).order("created_on DESC")
            projects = Issue.where(id: params[:ids]).group(:project_id).count
            if projects.size() == 1
              project_id, count = projects.first
              @project = Project.find(project_id)
              date = Time.now.strftime('%F')
              @datestr = date
              @title = l("invoice_filename", date: date, project_name: @project.name)
            end
        end
    end

  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
