#
# Be sure to run `pod lib lint MTACodable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MTACodable'
  s.version          = '0.1.0'
  s.summary          = '基于 Swift Codable 序列化、反序列化的能力进行修改，方便使用且进行一些容错处理。'

#

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/吴伟毅/MTACodable'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '吴伟毅' => 'wwy3@meitu.com' }
  s.source           = { :git => 'https://github.com/吴伟毅/MTACodable.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'MTACodable/Classes/**/*'
  
  s.pod_target_xcconfig = {
    'OTHER_SWIFT_FLAGS' => '-load-plugin-executable ${PODS_ROOT}/MTACodable/MTACodable/Classes/Macros/Code/.build/release/DecodeMembersMacros#DecodeMembersMacros'
  }
  
  s.user_target_xcconfig = {
    'OTHER_SWIFT_FLAGS' => '-load-plugin-executable ${PODS_ROOT}/MTACodable/MTACodable/Classes/Macros/Code/.build/release/DecodeMembersMacros#DecodeMembersMacros'
  }
end
