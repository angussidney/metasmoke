class SearchController < ApplicationController
  def search
    @results = Post.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 100)
    @sites = Site.where(:id => @results.map(&:site_id))
  end
  def search_results
    @results = Post.where("username LIKE :username AND title LIKE :title AND body LIKE :body", username: "%" + params[:username] + "%", title: "%" + params[:title] + "%", body: "%" + params[:body] + "%").paginate(:page => params[:page], :per_page => 100).order("created_at DESC")

    if params[:site].present?
      site_id = Site.find_by_site_name(params[:site])
      @results = @results.where(:site_id => site_id)
    end

    @sites = Site.where(:id => @results.map(&:site_id))

    render :search
  end
end