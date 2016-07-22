module ApplicationHelper

  def redirect_back_link(default = '/')
    if request.referer.present?
      request.referer
    else
      default
    end
  end

  def product_image product, options = {}
    if product.images.empty?
      image_tag 'noimage/product.png', options
    else
      image = product.images.where(search_result_asset: true).first
      image = product.images.first unless image
      options.reverse_merge! alt: image.alt.blank? ? product.name : image.alt.tr('"','').tr('\'','')
      options.reverse_merge!({src: image.attachment.url(:large) })
      img = '<img '
      options.keys.each do |k|
        img += "#{k}=#{options[k]} "
      end
      img += '/>'
      img.html_safe
    end
  end

  def country_select_link(country, id)
    content_tag(:li, class: session[:country_id] == id ? 'selected': '') do
      link_to(country, "/country/set?country_id=#{id}")
    end
  end

  def spree_nav_link(text, link)
    content_tag(:li, class: request.fullpath.gsub('//','/') == link ? 'selected': '') do
      link_to(text, link)
    end
  end

  def taxons_nav_filters(root_taxon, current_taxon, max_level = 1)
    other_filters = get_brands_for_category
    other_filters='' if other_filters==nil
    return '' if max_level < 1 || root_taxon.children.empty?
    content_tag :ul, class: 'categories filter', id: "filter_#{root_taxon.id}" do
      root_taxon.children.map do |taxon|
        css_class = nil
        if(params && params['filters'] && params['filters'].include?(taxon.name.strip))
          css_class = 'selected'
        end
        taxon_filter_url = request.path + '?' + taxon.to_filter_params(params) + other_filters
        if css_class == 'selected'
          content_tag :li, class: css_class do
            link_to taxon_filter_url do
              taxon.name.html_safe +
              "<span class='remove_filter'>Remove filter</span>".html_safe +
              content_tag(:span, class: 'ss-icon filter-close') do
                '&#x2421'.html_safe
              end
            end
          end

        else
          content_tag :li, class: css_class do
            link_to(taxon.name, taxon_filter_url)
          end
        end
      end.join('').html_safe
    end
  end

  def brands_nav_filters(brands, max_level = 1)
    other_filters = get_filters_for_category
    other_filters='' if other_filters==nil
    content_tag :ul, class: 'categories filter', id: 'filter_00' do
      brands.map do |brand|
        css_class = nil
        if(params && params["brands"] && params["brands"].include?("#{brand.name.strip}"))
          css_class = "selected"
        end
        brand_filter_url = request.path + "?" + brand.to_filter_params(params) + other_filters
        if css_class == 'selected'
          content_tag :li, class: css_class do
            link_to brand_filter_url do
              brand.name.html_safe +
                  "<span class='remove_filter'>Remove filter</span>".html_safe +
                  content_tag(:span, class: 'ss-icon filter-close') do
                    '&#x2421'.html_safe
                  end
            end
          end

        else
          content_tag :li, class: css_class do
            link_to(brand.name, brand_filter_url)
          end
        end
      end.join('').html_safe
    end
  end

  def taxons_nav(root_taxon, current_taxon, max_level = 1)
    html = ''
    return '' if max_level < 1 || root_taxon.children.empty?
    content_tag :ul, class: 'categories' do
      if current_taxon && !current_taxon.brand?
        if current_taxon.children.empty? and current_taxon.parent.root?
          child_taxons = [current_taxon]
        elsif current_taxon.children.empty?
          child_taxons = ([current_taxon.parent] << current_taxon.parent.children).flatten
        else
          child_taxons = ([current_taxon] << current_taxon.children).flatten
        end

        html += content_tag :li, class: 'back' do
          if current_taxon.try(:parent).try(:id) == root_taxon.id
            link_to "/collection" do
              "<span></span>Back to #{current_taxon.parent.name}".html_safe
            end
          else
            if current_taxon.children.empty? && current_taxon.parent.parent && current_taxon.parent.parent.id == root_taxon.id
              link_to "/collection" do
                "<span></span>Back to #{current_taxon.parent.parent.name}".html_safe
              end
            elsif current_taxon.parent
              link_to seo_url(current_taxon.parent) do
                "<span></span>Back to #{current_taxon.parent.name}".html_safe
              end
            end

          end
        end
      else
        child_taxons = root_taxon.children
      end

      child_taxons.map do |taxon|
        css_class = (current_taxon && current_taxon.self_and_ancestors.include?(taxon)) ? 'selected' : nil
        html += content_tag :li, class: css_class do
          if css_class == 'selected'
            link_to('All ' + taxon.name, seo_url(taxon)) + taxons_nav(taxon, current_taxon, 0)
          else
            link_to(taxon.name, seo_url(taxon)) + taxons_nav(taxon, current_taxon, 0)
          end
        end
      end
      html.html_safe
    end
  end

  def get_filters_for_category
    return_val='';
    if params[:filters].present?
      params[:filters].each do |filter|
        return_val = return_val + "&filters[]="+filter
      end
      return return_val;
    else
      return nil;
    end
  end

  def get_brands_for_category
    return_val='';
    if params[:brands].present?
      params[:brands].each do |brand|
        return_val = return_val + "&brands[]="+brand
      end
      return return_val;
    else
      return nil;
    end
  end
  
  def get_taxon(taxon_id)
    Spree::Taxon.find_by_id(taxon_id)
  end
  
  def get_background_image(taxon)
    Spree::Background.find_by_taxon_id(taxon.id)
  end
  
  def all_taxon_filters(taxon)
    taxon.filters.sort_by(&:name).reverse
  end
  
  def get_slider1_images
    @slider1_imgs = CollectionImage.where(position: 1)
  end
  
  def get_slider2_images
	  @slider2_imgs = CollectionImage.where(position: 2)
  end
  
  def get_slider3_images
	  @slider2_imgs = CollectionImage.where(position: 3)
  end
  
  def get_slider4_images
	  @slider2_imgs = CollectionImage.where(position: 4)
  end
  
  def get_slider5_images
	  @slider2_imgs = CollectionImage.where(position: 5)
  end
  
  def get_slider6_image
	  @slider6_imgs = CollectionImage.where(position: 6).first
  end
  
  def get_slider6_hoover_image
	  @slider6_hoover_imgs = CollectionImage.where(position: 7).first
  end
  
  def get_medium_images_block1
    @medium_images = CollectionImage.where(position: 2..5)
  end
  
  def get_small_images_block1
    @small_imgs = CollectionImage.where(small: true).first(4)
  end
  
  def get_medium_images_block2
    @medium_images = CollectionImage.where(medium: true).limit(2).offset(4)
  end
  
  
  def get_medium_images_block3
    @medium_images = CollectionImage.where(medium: true).limit(4).offset(6)
  end
  
  def get_small_images_block2
    @small_imgs = CollectionImage.where(small: true).limit(4).offset(4)
  end

  def get_hove_over_image
	  @hove_over_image = CollectionImage.where(hove_over: true).first	
  end
  
  def money(count)
    Spree::Money.new(count).to_html
  end
  
  def get_code_from_country(country_name)
    case country_name.downcase
      when "saint lucia"    
        return "lc" 
      when "panama"
        return "pa"
      when "mexico"
        return "mx"
      when "dominican republic"
        return "do"
      when "costa rica"
        return "cr"
      when "united states"
        return "us"
      when "united arab emirates"
        return "ae"
      when "turkey"
        return "tr"
      when "thailand"
        return "th"
      when "singapore"
        return "sg"
      when "saudi arabia"
        return "sa"
      when "russian federation"
        return "ru"
      when "qatar"
        return "qa"
      when "philippines"
        return "ph"
      when "pakistan"
        return "pk"
      when "oman"
        return "om"
      when "malaysia"
        return "my"
      when "lebanon"
        return "lb"
      when "kuwait"
        return "kw"
      when "hong kong"
        return "hk"
      when "south korea"
        return ""
      when "jordan"
        return "jo"
      when "japan"
        return "jp"
      when "israel"
        return "il"
      when "indonesia"
        return "id"
      when "india"
        return "in"
      when "china"
        return "cn"
      when "brunei darussalam"
        return "bn"
      when "bahrain"
        return "bh"
      when "united kingdom"
        return "gb"
      when "ukraine"
        return "ua"
      when "switzerland"
        return "ch"
      when "sweden"
        return "se"
      when "spain"
        return "es"
      when "san marino"
        return "sm"
      when "romania"
        return "ro"
      when "portugal"
        return "pt"
      when "poland"
        return "pl"
      when "norway"
        return "no"
      when "netherlands"
        return "nl"
      when "monaco"
        return "mc"
      when "malta"
        return "mt"
      when "luxembourg"
        return "lu"
      when "lithuania"
        return "lt"
      when "liechtenstein"
        return "li"
      when "italy"
        return "it"
      when "ireland"
        return "ie"
      when "hungary"
        return "hu"
      when "greece"
        return "gr"
      when "germany"
        return "de"
      when "france"
        return "fr"
      when "finland"
        return "fi"
      when "estonia"
        return "ee"
      when "denmark"
        return "dk"
      when "czech republic"
        return "cz"
      when "cyprus"
        return "cy"
      when "bulgaria"
        return "bg"
      when "bosnia and herzegovina"
        return "ba"
      when "belgium"
        return "be"
      when "azerbaijan"
        return "az"
      when "austria"
        return "at"
      when "new zealand"
        return "nz"
      when "australia"
        return "au"
      when "venezuela"
        return "ve"
      when "uruguay"
        return "uy"
      when "suriname"
        return "sr"
      when "brazil"
        return "br"
      when "argentina"
        return "ar"
      when "south africa"
        return "za"
      when "morocco"
        return "ma"
      when "kenya"
        return "ke"
      when "egypt"
        return "eg"
      else
        return "nl"
    end
  end
end
