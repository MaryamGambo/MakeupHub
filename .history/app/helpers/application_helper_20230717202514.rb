module ApplicationHelper
  def navigation_breadcrumbs
    breadcrumbs = []

    # Add the root breadcrumb
    breadcrumbs << link_to('Products', root_path)

    # Add the first-level breadcrumb if applicable (e.g., products)
    if @product
      breadcrumbs << link_to(@product.brand.name, category_path(@product.category))
    end

    # Add the second-level breadcrumb if applicable (e.g., categories)
    if @category
      breadcrumbs << link_to(@category.name, category_path(@category))
    end

    # Add the third-level breadcrumb if applicable (e.g., subcategories)
    if @subcategory
      breadcrumbs << link_to(@subcategory.name, category_path(@subcategory))
    end

    breadcrumbs.join(' / ').html_safe
  end
end
