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
				@collection_image = CollectionImage.new(params[:collection_image])
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
				if @collection_image.update_attributes(params[:collection_image])
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
    end
  end
end
