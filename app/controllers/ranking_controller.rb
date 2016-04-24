class RankingController < ApplicationController
    
    before_action :logged_in_user
    
    def show
        if params[:id] == "want"
            @items = Want.limit(10).group(:item_id).order('count_all desc').count
        elsif params[:id] == "have"
            @items = Have.limit(10).group(:item_id).order('count_all desc').count
        end
    
    end
    
end
