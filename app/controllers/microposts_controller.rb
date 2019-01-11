class MicropostsController < ApplicationController
    before_action :signed_in_user, only: [:create, :destroy]
    before_action :correct_user,   only: :destroy

    def create
        @micropost = current_user.microposts.build(micropost_params)
        if @micropost.save
            flash[:success] = "Micropost created!"
            redirect_to root_url
        else
            @feed_items = []
            render 'static_pages/home'
        end
    end

    def destroy
        @micropost.destroy
        redirect_to root_url
    end

    private

    def micropost_params
        params.require(:micropost).permit(:content)
    end

    #查看当前用户是否发布了指定用户的微博
    def correct_user
        #关联查找
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
    end
end