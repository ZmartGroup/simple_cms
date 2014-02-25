class CmsTextsController < Cms.parent_controller

  http_basic_authenticate_with :name => Cms.username, :password => Cms.password

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
    Cms.mailers.each_with_index.map {|o, index| [index, o[0], o[1].length > 1 ? " - #{o[1][:description]}" : '']}
  end

  def index
    @pages = CmsTextsController.pages
    @mailers = CmsTextsController.mailers
  end

  def edit
    @page = params[:page_name]
    @rendered_page = inject_editor(editable_page(@page))
    render layout: false
  end

  def edit_email
    @email = Cms.mailers[params[:email_name].to_i]
    @rendered_email = editable_email(@email)
  end

  def update
    @cms_text = CmsText.find(params[:cms_text][:id])
    @cms_text.value = params[:cms_text][:value].gsub('<', '&lt;').gsub('>', '&gt;')
    @cms_text.save!

    CmsTextsController.clear_cms_cache
    render nothing: true
  end

  private

  def editable_page(page)
    # Setup a dummy controller and render the page to be edited
    controller_name, action_name = page.split('#')
    controller_name = controller_name.split('::').map {|a| a.capitalize }.join('::')
    controller = Kernel.const_get("#{controller_name}Controller").new
    controller.instance_variable_set(:@is_editor, true)
    controller.request = self.request
    controller.send(action_name)
    controller.render_to_string(action_name)
  end

  def editable_email(email)
    mailer_name, action_name = email.first.split('#')

    if mailer_name.include? '::'
      mailer_name = mailer_name.split('::')
      base = mailer_name[0]

      mailer = mailer_name[1..-1].inject(Kernel.const_get(base)) {|a,b| a.const_get(b)}
    else
      mailer = Kernel.const_get(mailer_name)
    end
    mailer.layout(false)
    mailer.instance_variable_set(:@is_editor, true)

    # Since mailers cannot be instanciated @is_editor cannot be injected the same way as for controllers, hence the extra param here
    args = email.last[:args] + [true]
    mailer.send(action_name, *args)
  end

  def inject_editor(preview_html)
    editor_header = render_to_string(:editor_header, layout: nil)
    editor_modal = render_to_string(:editor_modal, layout: nil)
    preview_html.sub('</head>', editor_header + '</head>').sub('</body>', editor_modal + '</body>')
  end

  def editor_modal
  end

  def editor_header
  end

  def cms_text_params
    params.require(:cms_text).permit(:id, :value)
  end
end
