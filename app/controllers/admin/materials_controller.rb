class Admin::MaterialsController < Admin::BaseController
  def create
    @material = Material.where(name: material_params[:name]).first_or_create
    respond_to do |format|
      format.js
    end
  end
  
  private
  
    def material_params
      params.require(:material).permit(:name)
    end
    
end