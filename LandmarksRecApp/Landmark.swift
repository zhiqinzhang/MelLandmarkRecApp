//
//  Landmark.swift
//  LandmarksRecApp
//
//  Created by Zhiqin Zhang on 2019/5/2.
//  Copyright © 2019 Zhiqin Zhang. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Landmark: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let category: String
    let coordinate: CLLocationCoordinate2D
    let longDescription: String
    
    
    var imageName: String? {
        if category == "Landmark" { return "landmark-64px" }
        return "location-pin-64x"
    }
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, longDescription: String) {
        self.title = title
        self.locationName = locationName
        self.category = discipline
        self.coordinate = coordinate
        self.longDescription = longDescription
        
        super.init()
    }
    
    init?(details: Dictionary<String, AnyObject>) {
        self.title = details["title"] as? String
        self.locationName = details["locationName"]! as! String
        self.category = details["category"]! as! String
        if let coordinate = details["coordinate"] as? [String] {
            let latitude = Double(coordinate[0])
            let longitude = Double(coordinate[1])
            self.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
        self.longDescription = details["longDescription"]! as! String
    }
    
    var subtitle: String? {
        return locationName
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
