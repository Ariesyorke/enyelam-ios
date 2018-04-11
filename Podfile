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
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'SideMenu', '~> 2.3.4'
  pod 'UINavigationControllerWithCompletionBlock'
  pod 'ActionSheetPicker-3.0', '~> 2.3.0'
  pod 'ImageSlideshow', '~> 1.3.0'
  pod 'ImageSlideshow/Alamofire'
  pod 'GradientView', '~> 2.2.0'
  pod 'Alamofire'
  pod 'PayPal-iOS-SDK'
  pod 'EAIntroView'
  pod 'MidtransCoreKit'
  pod 'MidtransKit'
  pod 'MMNumberKeyboard'
  pod 'PopupController'
  pod 'MBProgressHUD', '~> 1.1.0'
  pod 'SkyFloatingLabelTextField', '~> 3.0'

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
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
  end
end
