class Admin::ColorsController < Admin::BaseController
  def create
    @color = Color.where(name: color_params[:name]).first_or_create
    @index = params[:index]
    respond_to do |format|
      format.js
    end
  end
  
  private
  
    def color_params
      params.require(:color).permit(:name)
    end
  
end