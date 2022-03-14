//
//  HotelStore.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 11/03/2022.
//

import Foundation

struct HotelStore: Codable {
    
    let hotels: [String: Hotel]
    var hotelArray: [Hotel]?
    var filteredHotelArray: [Hotel]?
    var isDownloadingHotels: Bool?
    var sortedBy: SortBy? = .None
    
    mutating func sortHotels(by sortOption: SortBy) {
        switch sortOption {
        case .None:
            break
        case .Recommended:
            hotelArray?.sort(by: { $0.priorityScore > $1.priorityScore })
            filteredHotelArray?.sort(by: { $0.priorityScore > $1.priorityScore })
        case .LowestPrice:
            hotelArray?.sort(by: {
                if let firstElementPrice = $0.price {
                    if let secondElementPrice = $1.price {
                        return firstElementPrice < secondElementPrice
                    } else {
                        return true
                    }
                } else {
                    return false
                }
            })
            filteredHotelArray?.sort(by: {
                if let firstElementPrice = $0.price {
                    if let secondElementPrice = $1.price {
                        return firstElementPrice < secondElementPrice
                    } else {
                        return true
                    }
                } else {
                    return false
                }
            })
        case .StarRating:
            hotelArray?.sort(by: { $0.starRating ?? 0 > $1.starRating ?? 0 })
            filteredHotelArray?.sort(by: { $0.starRating ?? 0 > $1.starRating ?? 0 })
        case .Distance:
            hotelArray?.sort(by: { $0.distanceInMeters < $1.distanceInMeters })
            filteredHotelArray?.sort(by: { $0.distanceInMeters < $1.distanceInMeters })
        }
        sortedBy = sortOption
    }
    
    mutating func filterHotelsForSearchBarText(_ searchBarText: String) {
        filteredHotelArray = hotelArray?.filter {
            if let hotelName = $0.name[languageCode] {
                return hotelName.lowercased().contains(searchBarText.lowercased())
            } else {
                return false
            }
        }
    }
    
}

enum SortBy: Codable {
    case None, Recommended, LowestPrice, StarRating, Distance
}
