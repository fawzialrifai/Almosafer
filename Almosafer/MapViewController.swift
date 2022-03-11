//
//  MapViewController.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 11/03/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet private var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: 25.2048, longitude: 55.2708)
        title = "Dubai, United Arab Emirates"
        let coordinateRegion = MKCoordinateRegion(
            center: initialLocation.coordinate,
            latitudinalMeters: 20000,
            longitudinalMeters: 20000)
        mapView.setRegion(coordinateRegion, animated: true)
        let hotel = Hotel(title: "Best Western Plus Seraphine Hammersmith Hotel", coordinate: CLLocationCoordinate2D(latitude: 25.097271599664083, longitude: 55.17477966749379))
        mapView.addAnnotation(hotel)
    }
    
}
