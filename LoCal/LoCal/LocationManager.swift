//
//  LocationManager.swift
//  LoCal
//
//  Created by Tyler Reardon on 2/23/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import Foundation
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate  {
    var manager:CLLocationManager!
    var currentLocation:CLLocation!
    var locationLookupHandler:((location: String?) -> Void)?
    
    override init(){
        super.init()
        
        manager = CLLocationManager()
        currentLocation = CLLocation()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        //DO NULL CHECKING HERE!
        getAddressFromLocation(locations.first!, completion: locationLookupHandler!)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }

    //returns the user's current location
    func getGeoLocation() -> CLLocation {
        currentLocation = manager.location
        
        getAddressFromLocation(currentLocation) { (location) -> Void in
            
            print(location)
        }
        return currentLocation
    }
    
    func getAddressFromCurrentLocation(completion: (location: String?) -> Void) {
        locationLookupHandler = completion
        manager.requestLocation()
    
    }
    
    func getAddressFromLocation(location: CLLocation, completion: (location: String?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                completion(location: nil)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                //print(pm.addressDictionary)     //everything
//                print(pm.name!)                  //address line
//                print(pm.locality!)              //city name
//                print(pm.administrativeArea!)    //state abbreviation
//                print(pm.postalCode!)            //zipcode
//                print(pm.country!)               //country
                completion(location: "\(pm.name!) \(pm.locality!), \(pm.administrativeArea!) \(pm.postalCode!) \(pm.country!)")
            }
            else {
                print("Problem with the data received from geocoder")
                completion(location: nil)
            }
        })
    }
}