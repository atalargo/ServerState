
Rails.configuration.after_initialize do
# 	I18n.load_path.unshift File.expand_path(File.join(File.dirname(__FILE__), 'locales', 'en.yml'))
	I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'locales', '*.yml')]
end
