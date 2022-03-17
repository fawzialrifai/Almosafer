//
//  ClusterAnnotationView.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 16/03/2022.
//

import UIKit
import MapKit

class ClusterAnnotationView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            canShowCallout = false
            if let cluster = newValue as? MKClusterAnnotation {
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
                image = renderer.image { _ in
                    // Fill circle with color
                    UIColor(named: "AlmosaferColor")?.setFill()
                    UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
                    // Draw count text vertically and horizontally centered
                    let annotationsCount = "\(cluster.memberAnnotations.count)"
                    let rect = CGRect(x: 20 - annotationsCount.size().width / 2, y: 20 - annotationsCount.size().height / 2, width: annotationsCount.size().width, height: annotationsCount.size().height)
                    annotationsCount.draw(in: rect, withAttributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                }
            }
        }
    }
    
}
