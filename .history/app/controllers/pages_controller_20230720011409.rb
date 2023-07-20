class PagesController < ApplicationController

  def permalink
    @page = Page.find_by_permalink(params[:permalink])
    render :show
  end

  def show
    @page = Page.find_by(params[:id])
  end
end
