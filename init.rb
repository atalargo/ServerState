# Include hook code here
require 'server_state'
#File.copy(File.dirname(__FILE__)+'/app/assets/javascripts/server_state.js', Rails.root+'/public/javascripts')
ActionView::Helpers::AssetTagHelper.register_javascript_expansion :server_state => ['server_state']
