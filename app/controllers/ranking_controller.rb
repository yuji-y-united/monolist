class RankingController < ApplicationController
    
    before_action :logged_in_user
    
    def show
        if params[:id] == "want"
            items = Want.select("item_id").uniq
            items = Item.where(id: items)
            items = items.sort { |a, b|
                b.want_users.count <=> a.want_users.count
            }
            if items.count > 10
                for i in 0..9 do
                    @items << items[i]
                end
            else
               @items = items 
            end
            p @items.first.want_users.count
        elsif params[:id] == "have"
            items = Have.select("item_id").uniq
            items = Item.where(id: items)
            items = items.sort { |a, b|
                b.have_users.count <=> a.have_users.count
            }
            if items.count > 10
                for i in 0..9 do
                    @items << items[i]
                end
            else
               @items = items 
            end
        end
    
    end
    
end
