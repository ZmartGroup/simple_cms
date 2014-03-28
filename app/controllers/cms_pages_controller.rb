class CmsPagesController < Cms.parent_controller

  authorize_actions_for :lazy_authority_class, except: [:index, :show]
  layout Cms.layout

  def index
    @pages = CmsPage.all
    render layout: Cms.sub_page_layout
  end

  def show
    @cms_page = CmsPage.find_by_url(request.params['url'])
    render layout: Cms.sub_page_layout
  end

  def new
    @cms_page = CmsPage.new
  end

  def create
    p = request.params[:cms_page]
    body = Sanitize.clean(p['body'], :elements => allowed_elements)
    @cms_page = CmsPage.new(url: p['url'], title: p['title'], body: body)

    if @cms_page.save
      flash[:success] = "The page #{@cms_page.title} was saved successfully"
      redirect_to cms_texts_path
    else
      render :new
    end
  end

  def edit
    @cms_page = CmsPage.find(request.params['id'])
  end

  def update
    p = request.params[:cms_page]
    @cms_page = CmsPage.find(request.params['id'])
    @cms_page.url = p['url']
    @cms_page.title = p['title']
    @cms_page.body = Sanitize.clean(p['body'], :elements => allowed_elements)
    if @cms_page.save
      flash[:success] = "The page #{@cms_page.title} was updated successfully"
      redirect_to cms_texts_path
    else
      render :edit
    end
  end

  def destroy
    @cms_page = CmsPage.find(request.params['id'])
    flash[:success] = "The page #{@cms_page.title} was deleted successfully"
    @cms_page.destroy
    redirect_to cms_texts_path
  end

  private

  def load_class(class_name)
    if class_name.include? '::'
      class_name = class_name.split('::')
      base = class_name[0]
      class_name[1..-1].inject(Kernel.const_get(base)) {|a,b| a.const_get(b)}
    else
      Kernel.const_get(class_name)
    end
  end

  def lazy_authority_class
    load_class(Cms.authorizer_name)
  end

  def allowed_elements
    %w[a br dd dl dt i ol p div b u i ul li h2 h3]
  end
end
