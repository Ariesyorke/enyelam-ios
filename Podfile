# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Nyelam' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Nyelam

  pod 'GoogleSignIn'
  pod 'FacebookCore', '0.3.0'
  pod 'FacebookLogin', '0.3.0'
  pod 'FacebookShare', '0.3.0'
  pod 'Google/Analytics', '~> 2.0.4'
  pod 'SideMenu', '~> 2.3.4'
  pod 'UINavigationControllerWithCompletionBlock'
  pod 'ActionSheetPicker-3.0', '~> 2.3.0'
  pod 'ImageSlideshow', '~> 1.3.0'
  pod 'ImageSlideshow/Alamofire'
  pod 'EZYGradientView', :git => 'https://github.com/Niphery/EZYGradientView'
  pod 'Alamofire'
  pod 'EAIntroView'
  pod 'MidtransCoreKit'
  pod 'MidtransKit'
  pod 'MMNumberKeyboard'
  pod 'PopupController'
  pod 'MBProgressHUD', '~> 1.1.0'
  pod 'SkyFloatingLabelTextField', '~> 3.4.0'
  pod 'Cosmos'
  pod 'SwiftDate'
  pod 'UIScrollView-InfiniteScroll'
  pod 'DLRadioButton', '~> 1.4'
  pod 'RangeSeekSlider'
  pod 'TangramKit'
  pod 'GSKStretchyHeaderView'
  pod 'XLPagerTabStrip', '~> 8.0'
  pod 'Firebase/Core'
  pod 'Firebase/Crash'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'KMPlaceholderTextView'
  pod 'EAIntroView'
  pod 'MultilineTextField'
  pod 'SimpleImageViewer', '~> 1.1.1'
  pod 'CollectionKit', '~> 2.1.0'
  
  target 'NyelamTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'NyelamUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings.delete('CODE_SIGNING_ALLOWED')
              config.build_settings.delete('CODE_SIGNING_REQUIRED')
          end
      end
  end
end
