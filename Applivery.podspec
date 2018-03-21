Pod::Spec.new do |s|
  s.name         = "Applivery"
  s.version      = "2.6.1"
  s.summary      = "Mobile App Distribution"
  s.homepage     = "https://www.applivery.com"
  s.license      = { :type => "LGPL-3.0", :file => "LICENSE" }
  s.author             = { "Alejandro Jiménez Agudo" => "alejandro@applivery.com" }
  s.social_media_url   = "https://twitter.com/Applivery"
  s.source       = { :git => "https://github.com/applivery/applivery-ios-sdk.git", :tag => "v#{s.version}" }
  s.platform     = :ios, "8.0"
  s.source_files  = "AppliverySDK/Applivery/**/*.swift"
  s.resources = ["AppliverySDK/**/*.storyboard", "AppliverySDK/**/*.strings"]
  s.swift_version = "3.2"
end
