Pod::Spec.new do |s|

  s.name         = "FaveButton"
  s.version      = "1.1.0"
  s.summary      = "Cute animated like button"
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/xhamr/fave-button'
  s.author       = { 'Jansel Valentin' => 'jvra16@gmail.com' }
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/xhamr/fave-button.git', :tag => s.version.to_s }
  s.source_files  = 'Source/**/*.swift'
  s.requires_arc = true
  end

