//
//  Hotel.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 11/03/2022.
//

import Foundation
import MapKit

class Hotel: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
