#
# Be sure to run `pod lib lint CRDropdownAlert.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CRDropdownAlert'
  s.version          = '1.0.3'
  s.summary          = 'Customizable dropdown alert written in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
CRDropdownAlert is a simple, easy-to-use alternative to DropdownAlert and RKDropdownAlert, written entirely in Swift. CRDropdownAlert was inspired by DropdownAlert, and adds functionality for custom views.
                       DESC

  s.homepage         = 'https://github.com/creitz/CRDropdownAlert'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Charles Reitz' => 'cgreitz@gmail.com' }
  s.source           = { :git => 'https://github.com/creitz/CRDropdownAlert.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.linkedin.com/in/reitzcharles/'

  s.ios.deployment_target = '9.0'

  s.source_files = 'CRDropdownAlert/Classes/*'
  
  s.dependency 'pop'
end
