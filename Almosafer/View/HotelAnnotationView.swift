//
//  HotelAnnotationView.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 16/03/2022.
//

import UIKit
import MapKit

class HotelAnnotationView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = "Hotel"
            markerTintColor = UIColor(named: "AlmosaferColor")
            glyphImage = UIImage(systemName: "building.2.crop.circle.fill")
            displayPriority = .defaultLow
            canShowCallout = true
            let rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            rightCalloutAccessoryView.tintColor = UIColor(named: "ButtonColor")
            self.rightCalloutAccessoryView = rightCalloutAccessoryView
        }
    }
    
}
