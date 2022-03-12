//
//  Hotel.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 11/03/2022.
//

import Foundation
import MapKit

class Hotel: NSObject, Codable, MKAnnotation {
    let name: [String: String]
    let thumbnailUrl: String
    let starRating: Int?
    let price: Int?
    let address: [String: String?]
    let review: Review?
    let priorityScore: Double
    let distanceInMeters: Double
    let latitude: Double
    let longitude: Double
    var imageData: Data?
    var downloaded: Bool?
    
    var title: String? {
        get { name["en"] }
    }
    var coordinate: CLLocationCoordinate2D {
        get { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
    }
    var attributedName: NSAttributedString {
        get {
            let title = "\(name["en"]!) \(ratingString)"
            let range = (title as NSString).range(of: ratingString)
            let mutableAttributedString = NSMutableAttributedString.init(string: title)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemYellow, range: range)
            return mutableAttributedString
        }
    }
    var ratingString: String {
        get {
            let ratingNumber: Int = starRating ?? 0
            var ratingString = ""
            for _ in 0..<ratingNumber {
                ratingString.append("★")
            }
            return ratingString
        }
    }
    var priceWithCurrency: String {
        if let price = price {
            return "AED \(price)"
        } else {
            return ""
        }
    }
    
    init(
        name: [String: String],
        thumbnailUrl: String,
        starRating: Int,
        price: Int,
        address: [String: String],
        priorityScore: Double,
        review: Review,
        distanceInMeters: Double,
        latitude: Double,
        longitude: Double
    ) {
        self.name = name
        self.thumbnailUrl = thumbnailUrl
        self.starRating = starRating
        self.price = price
        self.address = address
        self.review = review
        self.priorityScore = priorityScore
        self.distanceInMeters = distanceInMeters
        self.latitude = latitude
        self.longitude = longitude
    }
    
    struct Review: Codable {
        let count: Int
        let score: Double
        let scoreDescription: [String: String]
    }
    
}
