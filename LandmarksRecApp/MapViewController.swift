//
//  MapViewController.swift
//  LandmarksRecApp
//
//  Created by Zhiqin Zhang on 2019/5/2.
//  Copyright © 2019 Zhiqin Zhang. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var label: String = ""
    var initiallocation: [Double] = [0.0,0.0]
    var local_data: [String: AnyObject] = [:]
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    var landmarks: [Landmark] = []
    let button:UIButton = UIButton(type: UIButton.ButtonType.custom)
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadInitialData() {
        for (_,value) in self.local_data {
            if let details = value as? Dictionary<String, AnyObject> {
                let item = Landmark(details: details)!
                landmarks.append(item)
            }
        }
    }
    
    @IBAction func goToHome(_ sender: UIButton) {
        performSegue(withIdentifier: "homeViewSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set initial location in Honolulu
        let initialLocation = CLLocation(latitude: initiallocation[0], longitude: initiallocation[1])
        centerMapOnLocation(location: initialLocation)
        
        mapView.delegate = self

        mapView.register(ArtworkView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        self.loadInitialData()
        mapView.addAnnotations(landmarks)
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

}
    extension MapViewController: MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                     calloutAccessoryControlTapped control: UIControl) {
            let location = view.annotation as! Landmark
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMaps(launchOptions: launchOptions)
        }
    }
