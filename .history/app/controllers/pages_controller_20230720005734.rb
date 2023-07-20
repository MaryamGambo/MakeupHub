class PagesController < ApplicationController
  def show
    @page = Page.find_by(params[:id])
  end
end
