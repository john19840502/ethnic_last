module Spree
  module Admin
    module Impressions
      class ImagesController < ResourceController

        create.before :set_viewable
        update.before :set_viewable
        destroy.before :destroy_before

        def crop
          @product_dimension = Spree::Image.attachment_definitions[:attachment][:styles][:product].split("x").map(&:to_i)
        end

        private
        def load_resource
          @impression = Impression.find(params[:impression_id])

          if member_action?
            @object = @image = params[:id].nil? ? Spree::Image.new : Spree::Image.find(params[:id])
          else
            @collection = @images = @impression.images
          end
        end

        def location_after_save
          admin_impression_images_url(@impression)
        end

        def set_viewable
          @image.viewable_type = 'Spree::Impression'
          @image.viewable_id = @impression.id
        end

        def destroy_before
          @viewable = @image.viewable
        end

        def model_class
          Spree::Impression
        end

        def permitted_resource_params
          params[:image].present? ? params.require(:image).permit! : ActionController::Parameters.new
        end

      end
    end
  end
end