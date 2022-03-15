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
                    UIColor(named: "NavigationBarColor")?.setFill()
                    UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
                    // Fill inner circle with white color
                    UIColor(named: "NavigationBarColor")?.setFill()
                    UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()
                    // Draw count text vertically and horizontally centered
                    let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white]
                    let text = "\(cluster.memberAnnotations.count)"
                    let size = text.size(withAttributes: attributes)
                    let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
                    text.draw(in: rect, withAttributes: attributes)
                }
            }
        }
    }
    
}
