class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
 def can(right,securable=nil,user=nil)
		raise 'outside of securable resource' if (@chamber == nil && @ballot == nil && @proposal == nil && @board == nil && @securable == nil && securable == nil)
		raise 'no user supplied' if (user == nil && current_user == nil)
		
		x = (securable || @ballot || @proposal || @board || @securable || @chamber || @announcement).can?(user || current_user, right)
		return '*' if !x && current_user.admin?
		x
	end

	def can? right
		can right
	end
 
  def current_user
	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def check_for_user
    redirect_to '/sessions/new?return='+request.original_url unless current_user
  end
  
  def check_for_admin
    redirect_to '/home/index' unless current_user && current_user.admin?
  end

  def find_chamber
	unless @chamber
		if params[:chamber_id]
			@chamber = Chamber.find(params[:chamber_id])
		end
	end
  end
end
