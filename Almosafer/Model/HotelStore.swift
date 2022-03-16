//
//  HotelStore.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 11/03/2022.
//

import Foundation

class HotelStore: Codable {
    
    var hotels: [String: Hotel]
    var hotelArray = [Hotel]()
    var filteredHotelArray = [Hotel]()
    var isRefreshingHotelsData = false
    var sortedBy = SortBy.None
    enum CodingKeys: CodingKey { case hotels }
    
    init(hotels: [String: Hotel]) {
        self.hotels = hotels
    }
    
}

extension HotelStore {
    
    func getData(completionHandler: @escaping (() -> Void)) {
        if let url = URL(string: "https://sgerges.s3-eu-west-1.amazonaws.com/iostesttaskhotels.json") {
            isRefreshingHotelsData = true
            hotelArray.removeAll()
            URLSession.shared.dataTask(with: url) { data, _, error  in
                if let data = data {
                    isConnectedToInternet = true
                    self.parseData(data: data)
                } else {
                    isConnectedToInternet = false
                }
                self.isRefreshingHotelsData = false
                self.sortHotels(by: self.sortedBy)
                completionHandler()
            }.resume()
        }
    }
    
    func parseData(data: Data) {
        if let jsonHotels = try? JSONDecoder().decode(HotelStore.self, from: data) {
            hotels = jsonHotels.hotels
            for (_, value) in hotels {
                hotelArray.append(value)
            }
        }
    }
    
    func sortHotels(by sortOption: SortBy) {
        switch sortOption {
        case .None:
            break
        case .Recommended:
            hotelArray.sort(by: { $0.priorityScore > $1.priorityScore })
            filteredHotelArray.sort(by: { $0.priorityScore > $1.priorityScore })
        case .LowestPrice:
            hotelArray.sort(by: {
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
            filteredHotelArray.sort(by: {
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
            hotelArray.sort(by: { $0.starRating ?? 0 > $1.starRating ?? 0 })
            filteredHotelArray.sort(by: { $0.starRating ?? 0 > $1.starRating ?? 0 })
        case .Distance:
            hotelArray.sort(by: { $0.distanceInMeters < $1.distanceInMeters })
            filteredHotelArray.sort(by: { $0.distanceInMeters < $1.distanceInMeters })
        }
        sortedBy = sortOption
    }
    
    func filterHotelsForSearchBarText(_ searchBarText: String) {
        filteredHotelArray = hotelArray.filter {
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
