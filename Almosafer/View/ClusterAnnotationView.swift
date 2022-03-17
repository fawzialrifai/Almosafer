//
//  ClusterAnnotationView.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 16/03/2022.
//

import UIKit
import MapKit

class ClusterAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            if let cluster = newValue as? MKClusterAnnotation {
                let annotationsCount = "\(cluster.memberAnnotations.count)"
                let size = CGSize(width: annotationsCount.size().width + 24, height: annotationsCount.size().width + 24)
                canShowCallout = false
                let renderer = UIGraphicsImageRenderer(size: size)
                image = renderer.image { _ in
                    // Fill circle with color
                    UIColor(named: "AlmosaferColor")?.setFill()
                    UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.height)).fill()
                    // Draw count text vertically and horizontally centered
                    let rect = CGRect(x: size.width / 2 - annotationsCount.size().width / 2, y: size.height / 2 - annotationsCount.size().height / 2, width: size.width, height: size.height)
                    annotationsCount.draw(in: rect, withAttributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                }
            }
        }
    }
    
}
