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
    
}

enum SortBy: Codable {
    case None, Recommended, LowestPrice, StarRating, Distance
}
