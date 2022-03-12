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
    var hotels: [Hotel]!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Dubai, United Arab Emirates", comment: "The name of the city")
        let initialLocation = CLLocation(latitude: 25.2048493, longitude: 55.2707828)
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(coordinateRegion, animated: false)
        mapView.addAnnotations(hotels)
    }
    
}
