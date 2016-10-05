Pod::Spec.new do |s|

  s.name         = "FaveButton"
  s.version      = "2.0.2"
  s.summary      = "Twitter's heart like animated button written in Swift"
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/xhamr/fave-button'
  s.author       = { 'Jansel Valentin' => 'jvra16@gmail.com' }
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/xhamr/fave-button.git', :tag => s.version.to_s }
  s.source_files  = 'Source/**/*.swift'
  s.requires_arc = true
  end

