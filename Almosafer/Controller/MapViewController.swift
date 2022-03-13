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
        mapView.delegate = self
        let initialLocation = CLLocation(latitude: 25.2048493, longitude: 55.2707828)
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(coordinateRegion, animated: false)
        mapView.addAnnotations(hotels)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Hotel"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .system)
        }
        return view
    }
    
}
