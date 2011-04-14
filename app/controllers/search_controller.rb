class SearchController < ApplicationController
  def index
    @class = params[:class] || "topic"
    @query = params[:query] || ''
    unless @query.blank?
      if @class == "topic"
        results = Topic.find_with_ferret @query
        @results = pages_for(results  ,:per_page => 1,:page=> (params[:page] || 1))
      else
        results = Reply.find_with_ferret @query
        @results = pages_for(results  ,:per_page => 1,:page=> (params[:page] || 1))
      end
    end
  end
end
