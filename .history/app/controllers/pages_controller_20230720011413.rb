class PagesController < ApplicationController

  def permalink
    @page = Page.find_by_permalink(params[:permalink])
    render :show
  end

  def show

  end
end
