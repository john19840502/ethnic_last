module Spree
  module Admin
    class CollectionImagesController < Spree::Admin::BaseController
      respond_to :html
		  
			def index
				@collection_imgs = CollectionImage.all
			end

			def new
				@collection_image = CollectionImage.new
			end

			def create
				@collection_image = CollectionImage.new(collection_image_params)
				if @collection_image.save
					respond_with(@collection_image) { |format| format.html { redirect_to admin_collection_images_path } }
				else
					@collection_image
					render :new
				end
			end

			def edit
				@collection_image = CollectionImage.find(params[:id])
			end

			def update
				@collection_image = CollectionImage.find(params[:id])
				if @collection_image.update_attributes(collection_image_params)
					respond_with(@collection_image) { |format| format.html { redirect_to admin_collection_images_path } }
				else
					@collection_image
					render :edit
				end
			end

			def destroy
				@image = CollectionImage.find(params[:id])
				@image.destroy
				redirect_to admin_collection_images_path
			end

			private
			def collection_image_params
				params.require(:collection_image).permit(:name, :position, :url, :attachment,
                    :slider1, :slider2, :slider6, :hove_over, :medium, :small, :new_tab)
			end
    end
  end
end
