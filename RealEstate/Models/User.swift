//
//  User.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-06.
//

import Foundation
import CoreLocation

struct User: Codable, Identifiable {
    var id                  : String              = ""
    var profileImageUrl     : String              = ""
    var favoriteRealEstate  : [String]            = []
    var realEstates         : [String]            = []
    var phoneNumber         : String              = ""
    var email               : String              = ""
    var username            : String              = ""
    var isVerified          : Bool                = false
    var dayTimeAvailability : [DayTimeSelection]  = []
    var location            : CLLocationCoordinate2D = .init(latitude: 0.0, longitude: 0.0)

    var dictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}

struct DayTimeSelection: Hashable, Codable {
    var day: AvailabilityDay
    var fromTime: Date
    var toTime: Date
}

enum AvailabilityDay: String , CaseIterable, Codable, Identifiable {

    var id: String { rawValue }

    case saturday
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday

    var title: String {
        switch self {
        case .saturday:  return "Saturday"
        case .sunday:    return "Sunday"
        case .monday:    return "Monday"
        case .tuesday:   return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday:  return "Thursday"
        case .friday:    return "Friday"
        }
    }
}
