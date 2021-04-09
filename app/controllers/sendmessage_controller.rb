class SendmessageController < ApplicationController
def new
@send = Notification.new
end
def create
   @send = Notification.new(send_params)
   if @send.save
    redirect_to root_path, notice: "Successfully created messages"
   else
    render :new
    #再来一遍这个页面
   end
end

private


end