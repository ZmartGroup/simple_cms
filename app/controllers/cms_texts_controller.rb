class CmsTextsController < ActionController::Base

  http_basic_authenticate_with :name => Cms.username, :password => Cms.password

  layout './cms'

  def index
    @pages = pages
  end

  def edit
    @page = params[:page_name]
    @copy_text = CmsText.where("key LIKE '#{@page}%'")
    @rendered_page = inject_editor(editable_page(@page))
    render layout: false
  end

  def update
    @cms_text = CmsText.find(params[:cms_text][:id])
    @cms_text.value = params[:cms_text][:value]
    @cms_text.save!

    Rails.cache.delete(@cms_text.key.split('.').first)
    redirect_to cms_texts_path, :notice => "#{@cms_text.key} updated!"
  end

  private

  def editable_page(page)
    controller_name, action_name = page.split('#')
    controller = Kernel.const_get("#{controller_name.capitalize}Controller").new
    controller.request = self.request
    rendered_page = controller.render_to_string(action_name)
    @copy_text.each do |copy_text|
      editable_content = "<span id=\"ct_#{copy_text.id}\">#{copy_text.value}</span>"
      rendered_page = rendered_page.sub(copy_text.value, editable_content)
    end

    return rendered_page
  end

  def inject_editor(preview_html)
    @js_data = Hash[@copy_text.map{|ct| ["ct_#{ct.id}", ct.value]}].to_s.gsub(/=>/, ':')

    editor_header = render_to_string(:editor_header, layout: nil)
    editor_modal = render_to_string(:editor_modal, layout: nil)
    preview_html.sub('</head>', editor_header + '</head>').sub('</body>', editor_modal + '</body>')
  end

  def editor_modal
  end

  def editor_header

  end

  def pages
    Cms.controllers.map do |controller_name|
      controller = Kernel.const_get(controller_name)
      controller_readable = controller_name.sub('Controller', '').downcase
      (controller.action_methods - ApplicationController.action_methods).map do |name|
        "#{controller_readable}##{name}" unless name[0] == '_'
      end.select(&:present?)
    end.flatten.sort
  end

  def cms_text_params
    params.require(:cms_text).permit(:id, :value)
  end
end
