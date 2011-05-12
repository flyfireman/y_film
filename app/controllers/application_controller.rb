# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
#  include TagsHelper
  #令views能够调用各自的视图助手（helper）里的方法
  helper :all
  #令以下方法能在所有helper,views,controller中调用（来自restful-authentication插件）
  helper_method :logged_in?, :current_user
  #开启反CSRF (Cross-Site Request Forgery)攻击保护
  protect_from_forgery
  #过滤敏感字段
  filter_parameter_logging :password, :password_confirmation
  #发生错误时自动重定向页面
  #rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  # protected
 
  #def record_not_found
  #render :file => File.join(RAILS_ROOT, 'public', '404.html'), :status => 404
  #end
  def pages_for(result,options = {})
    page, per_page, total = (options[:page] || 1),(options[:per_page] || 30),(result.total_hits || 0)
    page_total = page * per_page
    index = (page.to_i - 1) * per_page
    returning WillPaginate::Collection.new(page, per_page, total) do |pager|
      pager.replace result[index,per_page]
    end
  end
end
