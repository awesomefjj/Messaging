class NotificationController < ApplicationController
    def new
        @user = Notification.new
        
    end
end