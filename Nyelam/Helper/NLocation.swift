//
//  NLocation.swift
//  Nyelam
//
//  Created by Bobi on 6/4/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreLocation

class NLocation: NSObject, CLLocationManagerDelegate {
    var locationManager:CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        switch status {
        case .notDetermined:
            print(".NotDetermined")
            break
            
        case .authorizedWhenInUse:
            print(".Authorized In Use")
            locationManager.startUpdatingLocation()
            break
        case .denied:
            print(".Denied")
            break
        case .authorizedAlways:
            print(". Authorized always")
            locationManager.startUpdatingLocation()
            break
        default:
            print("Unhandled authorization status")
            break
            
        }
    }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let curLoc = locations[locations.count - 1]
        self.currentLocation = curLoc
    }

}
