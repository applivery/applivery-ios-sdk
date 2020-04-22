Pod::Spec.new do |s|
  s.name                = "Applivery"
  s.version             = "3.1.2"
  s.summary             = "Mobile App Distribution"
  s.homepage            = "https://www.applivery.com"
  s.license             = { :type => "MIT", :file => "LICENSE" }
  s.author              = { "Alejandro Jiménez Agudo" => "alejandro@applivery.com" }
  s.social_media_url    = "https://twitter.com/Applivery"
  s.source              = { :git => "https://github.com/applivery/applivery-ios-sdk.git", :tag => "v#{s.version}" }
  s.platform            = :ios, "9.0"
  s.source_files        = "AppliverySDK/**/*.swift"
  s.exclude_files       = "AppliverySDK/**/getConstants.swift"
  s.resource_bundle     = { 'Applivery' => ["AppliverySDK/**/*.storyboard", "AppliverySDK/**/*.strings"] }
  s.swift_version       = "4.0"
end
