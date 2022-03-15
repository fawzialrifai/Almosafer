//
//  Hotel.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 11/03/2022.
//

import Foundation
import MapKit

class Hotel: NSObject, Codable {
    let price: Int?
    let name: [String: String]
    let starRating: Int?
    let thumbnailUrl: String
    let latitude: Double
    let longitude: Double
    let distanceInMeters: Double
    let address: [String: String?]
    let priorityScore: Double
    let review: Review?
    var thumbnailData: Data?
    var isThumbnailDownloaded: Bool?
    
    struct Review: Codable {
        let count: Int
        let score: Double
        let scoreDescription: [String: String]
        let scoreColor: String
    }
    
    init(
        price: Int,
        name: [String: String],
        starRating: Int,
        thumbnailUrl: String,
        latitude: Double,
        longitude: Double,
        distanceInMeters: Double,
        address: [String: String],
        priorityScore: Double,
        review: Review
    ) {
        self.price = price
        self.name = name
        self.starRating = starRating
        self.thumbnailUrl = thumbnailUrl
        self.latitude = latitude
        self.longitude = longitude
        self.distanceInMeters = distanceInMeters
        self.address = address
        self.priorityScore = priorityScore
        self.review = review
    }
    
    func downloadThumbnail(completionHandler: @escaping ((UIImage?) -> Void)) {
        if let url = URL(string: thumbnailUrl) {
            URLSession.shared.dataTask(with: url) { data,_,_ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.thumbnailData = data
                        self.isThumbnailDownloaded = true
                        completionHandler(UIImage(data: data))
                    }
                }
            }.resume()
        }
    }
    
}

extension Hotel {
    
    var attributedName: NSAttributedString {
        let ratingNumber = starRating ?? 0
        var ratingString = ""
        for _ in 0..<ratingNumber {
            ratingString.append("★")
        }
        let title = "\(name[languageCode] ?? "") \(ratingString)"
        let range = (title as NSString).range(of: ratingString)
        let attributedName = NSMutableAttributedString.init(string: title)
        attributedName.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemYellow, range: range)
        return attributedName
    }
    var priceWithCurrencyCode: String {
        if let price = price {
            return String(format: NSLocalizedString("AED %d", comment: "The currency code"), price)
        } else {
            return ""
        }
    }
    var thumbnail: UIImage? {
        if let thumbnailData = thumbnailData, isThumbnailDownloaded == true {
            return UIImage(data: thumbnailData)
        } else {
            return nil
        }
    }
    var localizedAddress: String {
        (address[languageCode] ?? "") ?? ""
    }
    
}

extension Hotel: MKAnnotation {
    
    var title: String? {
        get { name[languageCode] }
    }
    var subtitle: String? {
        get { priceWithCurrencyCode }
    }
    var coordinate: CLLocationCoordinate2D {
        get { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
    }
    
}
