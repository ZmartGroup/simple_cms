# Add ct view helper, use this to tag text for inclusion in the CMS
module ApplicationHelper
  def ct(key, default_text)
    if key.is_a?(String) && (key[0] == '.')
      key = "#{ controller_path.tr('/', '.') }.#{ action_name }#{ key }"
      args[0] = key
    end

    cms_text = CmsText.find_by_key(key.to_s)
    if cms_text
      return cms_text.value
    else
      CmsText.create(key: key.to_s, value: default_text)
      Rails.cache.delete(key.split('.').first)
      return default_text
    end
  end
end
