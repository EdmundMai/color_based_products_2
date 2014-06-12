class Admin::ShapesController < Admin::BaseController
  def create
    @shape = Shape.where(name: shape_params[:name]).first_or_create
    respond_to do |format|
      format.js
    end
  end
  
  private
  
    def shape_params
      params.require(:shape).permit(:name)
    end
    
end