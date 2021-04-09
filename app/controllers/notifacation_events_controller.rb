class Notification_EventsController < ApplicationController

    

    def new 
        @text=Text.new(params.require(:text)
        .permit(:content))

        if @text.save
            flash[:notice]="注册成功"
            redirect_to root_path
        else
            render action: :new
            
        end
        
    
    end

    
end