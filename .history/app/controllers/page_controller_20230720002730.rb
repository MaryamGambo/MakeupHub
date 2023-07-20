class PageController < ApplicationController
  def show
    @page = Page.find_by(title: params[:slug])
  end
end
