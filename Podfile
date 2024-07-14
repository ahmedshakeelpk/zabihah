# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'zabihah' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for zabihah

pod 'Alamofire'
pod "FlagPhoneNumber"
pod 'IQKeyboardManager'

#https://github.com/chronotruck/FlagPhoneNumber

pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'FirebaseAnalytics'

#Azure Blob Storage ImageUpload
#https://learn.microsoft.com/en-us/previous-versions/azure/storage/blobs/storage-ios-how-to-use-blob-storage#cocoapod
pod 'AZSClient'







post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      xcconfig_path = config.base_configuration_reference.real_path
               xcconfig = File.read(xcconfig_path)
               xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
               File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end

end
