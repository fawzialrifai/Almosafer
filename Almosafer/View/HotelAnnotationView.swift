//
//  HotelAnnotationView.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 16/03/2022.
//

import UIKit
import MapKit

class HotelAnnotationView: MKMarkerAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "Hotel"
        markerTintColor = UIColor(named: "AlmosaferColor")
        displayPriority = .defaultLow
        canShowCallout = true
        let rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        rightCalloutAccessoryView.tintColor = UIColor(named: "ButtonColor")
        self.rightCalloutAccessoryView = rightCalloutAccessoryView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
