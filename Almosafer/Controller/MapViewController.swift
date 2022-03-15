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
    var hotelArray: [Hotel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Dubai, United Arab Emirates", comment: "The name of the city")
        setUpMapRegion()
        registerAnnotationViewClasses()
        mapView.addAnnotations(hotelArray)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func setUpMapRegion() {
        let location = CLLocation(latitude: 25.2048493, longitude: 55.2707828)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func registerAnnotationViewClasses() {
        mapView.register(HotelAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
}
