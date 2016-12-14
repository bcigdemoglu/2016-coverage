//
//  LocationManager.swift
//  PlanIt
//
//  Created by Alex Owen on 12/13/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import Foundation
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    
    var state = BooleanLiteralType()
    
    private var mostRecentLocation : CLLocation?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        state = false
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                    state = true
                    manager.startMonitoringSignificantLocationChanges()
                    
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mostRecentLocation = locations.last
    }
    
    
    func getLocation() -> CLLocation? {
        return mostRecentLocation
    }

}
