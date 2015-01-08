# Add ct view helper, use this to tag text for inclusion in the CMS
module ApplicationHelper
  def ct(key, default_text)
    print_editor_tags = instance_variable_defined?(:@is_editor) && instance_variable_get(:@is_editor)
    cms_text = CmsText.find_by_key(key.to_s)

    unless cms_text
      begin
        cms_text = CmsText.create(key: key.to_s, value: default_text)
        CmsTextsController.clear_cms_cache
      rescue ActiveRecord::RecordNotUnique
        cms_text = CmsText.find_by_key(key.to_s)
      end
    end

    if print_editor_tags
      return "<span class=\"cms_editable\" id=\"ct_#{cms_text.id}\">#{cms_text.value}</span>".html_safe
    else
      return cms_text.value.html_safe
    end
  end
end
