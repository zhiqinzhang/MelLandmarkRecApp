//
//  LandmarkViews.swift
//  LandmarksRecApp
//
//  Created by Zhiqin Zhang on 2019/5/2.
//  Copyright © 2019 Zhiqin Zhang. All rights reserved.
//

import Foundation
import MapKit

class ArtworkView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let landmark = newValue as? Landmark else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            //rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "compase-64px"), for: UIControl.State())
            rightCalloutAccessoryView = mapsButton
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = landmark.longDescription
            detailCalloutAccessoryView = detailLabel
            
            if let imageName = landmark.imageName {
                image = UIImage(named: imageName)
            } else {
                image = nil
            }
        }
    }
}
