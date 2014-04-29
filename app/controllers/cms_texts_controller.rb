class CmsTextsController < Cms.parent_controller

  authorize_actions_for :lazy_authority_class, actions: {
    edit_email: :update,
    edit_pdf_letter: :update,
    preview_email: :read,
    preview_pdf_letter: :read,
  }
  layout Cms.layout

  def self.clear_cms_cache
    CmsTextsController.pages.each do |page_name|
      Rails.cache.delete(page_name)
    end
  end

  def self.pages
    Cms.controllers.map do |controller_name|
      controller = Kernel.const_get(controller_name)
      controller_readable = controller_name.sub('Controller', '').downcase
      (controller.action_methods - ApplicationController.action_methods).map do |name|
        "#{controller_readable}##{name}" unless name[0] == '_'
      end.select(&:present?)
    end.flatten.sort
  end

  def self.mailers
    Cms.mailers.each_with_index.map {|o, index| [index, o[0], o[1][:description]]}
  end

  def self.pdf_letters
    Cms.pdf_letters.each_with_index.map {|o, index| [index, o[0], o[1][:description]]}
  end

  def index
    @pages = CmsTextsController.pages
    @mailers = CmsTextsController.mailers
    @pdfs = CmsTextsController.pdf_letters
    @sub_pages = Cms.sub_pages ? CmsPage.all : []
  end

  def edit
    @page = request.params['page_name']
    @rendered_page = inject_editor(editable_page(@page))
    render layout: false
  end

  def edit_email
    @rendered_email = render_email
    @rendered_page = inject_editor(render_to_string(:editable_email))
    render layout: nil
  end

  def edit_pdf_letter
    @rendered_pdf = render_pdf_letter(false)
    @rendered_page = inject_editor(render_to_string(:editable_pdf_letter))
    render layout: nil
  end

  def update
    @cms_text = CmsText.find(request.params[:cms_text]['id'])
    value = Sanitize.clean(request.params['cms_text']['value'],
                           :elements => ['b', 'i', 'u', 'p', 'br'],
                           :output => :xhtml)
    @cms_text.value = value
    @cms_text.save!

    CmsTextsController.clear_cms_cache
    render text: value
  end

  def preview_email
    @rendered_page = render_email.body.to_s
    render "edit_email", layout: Cms.email_preview_layout
  end

  def preview_pdf_letter
    render text: render_pdf_letter(true), content_type: 'application/pdf'
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

  def editable_page(page)
    # Setup a dummy controller and render the page to be edited
    controller_name, action_name = page.split('#')
    controller_name = controller_name.split('::').map {|a| a.capitalize }.join('::')
    controller = load_class("#{controller_name}Controller").new
    controller.instance_variable_set(:@is_editor, true)
    controller.request = self.request
    controller.send(action_name)
    controller.render_to_string(action_name)
  end

  def inject_editor(preview_html)
    editor_header = render_to_string(:editor_header, layout: nil)
    editor_modal = render_to_string(:editor_modal, layout: nil)
    preview_html.sub('<head>', '<head>' + editor_header).sub('</body>', editor_modal + '</body>')
  end

  def editable_email
  end

  def editor_modal
  end

  def editor_header
  end

  def render_email
    @email_number = request.params['email_name'].to_i
    email = Cms.mailers[@email_number]
    mailer_name, action_name = email.first.split('#')
    mailer = load_class(mailer_name)
    mailer.layout(false)

    # Since mailers cannot be instanciated @is_editor cannot be injected the same way as for controllers, hence the extra param here
    args = email.last[:args] + [true]
    mailer.send(action_name, *args)
  end

  def render_pdf_letter(is_preview)
    @pdf_number = request.params['pdf_letter_index'].to_i
    pdf_letter = Cms.pdf_letters[@pdf_number]
    pdf_renderer_class_name, action_name = pdf_letter.first.split('#')
    letter_renderer = load_class(pdf_renderer_class_name)
    unless is_preview
      letter_renderer = letter_renderer.new
      letter_renderer.instance_variable_set(:@is_editor, true)
      letter_renderer.send(action_name, *pdf_letter.last[:args])
    end
    letter_renderer.send(action_name, *pdf_letter.last[:args])
  end
end
