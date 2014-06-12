class Admin::FileUploadsController < Admin::BaseController
  
  def index
  end
  
  def update_taxes
    if params[:tax_rates]
      directory = "public/file_uploads"
      file_name = "taxes_#{Date.today.strftime("%Y%m%d")}.csv"
      path = File.join(Rails.root, directory, file_name)
      begin
        file = File.open(path, "w") { |f| f.write(params[:tax_rates].read) }
        FileParser.update_tax_rates(path)
        redirect_to admin_path, notice: "Tax rate file is now being processed."
      rescue Exception => e
        # puts "e = #{e.inspect}"
        flash[:notice] = "There was something wrong with your file. Please try again."
        render :action => :index
      end
    end
  end
  
end