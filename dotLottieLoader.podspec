#
# Be sure to run `pod lib lint dotLottieLoader.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'dotLottieLoader'
  s.version          = '0.1.9'
  s.summary          = 'An iOS library to natively load .lottie files https://dotlottie.io/'

  s.description      = <<-DESC
dotLottieLoader is an open-source file format that aggregates one or more Lottie files and their associated resources into a single file. They are ZIP archives compressed with the Deflate compression method and carry the file extension of .lottie.
                       DESC

  s.homepage         = 'https://github.com/dotLottie/dotLottieLoader-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Evandro Harrison Hoffmann' => 'evandro.hoffmann@gmail.com' }
  s.source           = { :git => 'https://github.com/dotLottie/dotLottieLoader-ios.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/LottieFiles'

  s.swift_version = '5.0'
  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '6.0'

  s.source_files = 'Sources/**/*'

  s.dependency 'Zip', '>= 2.1.2'
end
