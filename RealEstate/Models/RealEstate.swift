//
//  RealEstate.swift
//  RealEstate
//
//  Created by Mahmoud Zinji on 2022-09-06.
//

import Foundation
import CoreLocation
import SwiftUI
import MapKit

enum SaleCategory: String, CaseIterable, Codable{
    case sale
    case rent
    case investment

    var title: String {
        switch self {
        case .sale:       return "Sale"
        case .rent:       return "Rent"
        case .investment: return "Investment"
        }
    }

    var saleColor: Color{
        switch self {
        case .sale:       return . green
        case .rent:       return .indigo
        case .investment: return .cyan
        }
    }

    var markedTitle: String{
        switch self {
        case .sale:       return "SOLD"
        case .rent:       return "RENTED"
        case .investment: return "Invseted"
        }
    }

    var imageName: String {
        switch self{
        case .sale:       return "dollarsign.circle.fill"
        case .rent:       return "dollarsign.arrow.circlepath"
        case .investment: return "chart.xyaxis.line"
        }
    }
}

enum RealEstateType: String, CaseIterable , Codable {
    case apartment
    case house
    case townHouse
    case farm
    case land
    case building
    case office
    case room
    case penthouse
    case floor
    case camp
    case chalet

    var title: String {
        switch self{
        case .apartment:  return "Apartment"
        case .house:      return "House"
        case .townHouse:  return "Town House"
        case .farm:       return "Farm"
        case .land:       return "Land"
        case .building:   return "Building"
        case .office:     return "Office"
        case .room:       return "Room"
        case .penthouse:  return "Penthouse"
        case .floor:      return "Floor"
        case .camp:       return "Camp"
        case .chalet:     return "Chalet"

        }
    }

    var imageName: String {
        switch self{
        case .apartment:  return "door.left.hand.closed"
        case .house:      return "house.fill"
        case .townHouse:  return "building.2.fill"
        case .farm:       return "laurel.trailing"
        case .land:       return "camera.macro"
        case .building:   return "building.fill"
        case .office:     return "briefcase.fill"
        case .room:       return "sofa.fill"
        case .penthouse:  return "building.2.crop.circle.fill"
        case .floor:      return "door.garage.double.bay.closed"
        case .camp:       return "tent.fill"
        case .chalet:     return "pedestrian.gate.closed"

        }
    }
}

enum OfferType: String, CaseIterable, Codable {
    case daily
    case monthly
    case yearly

    var title: String{
        switch self {
        case .daily:   return "Daily"
        case .monthly: return "Monthly"
        case .yearly:  return "Yearly"
        }
    }
}

enum City: String, CaseIterable, Codable {
    case arrass
    case qassim
    case riyadh
    case almadinah
    case meccah
    case tabuk
//    case najran
//    case jazan
//    case hail
//    case asir
//    case jawf
//    case bahah

    var title: String {
        switch self {
        case .arrass:    return "Alrass"
        case .qassim:    return "Alqassim"
        case .riyadh:    return "Riyadh"
        case .almadinah: return "Almadinah"
        case .meccah:    return "Meccah"
        case .tabuk:     return "Tabuk"
//        case .najran:    return "Najran"
//        case .jazan:     return "Jazan"
//        case .hail:      return "Hail"
//        case .asir:      return "Asir"
//        case .jawf:      return "Jawf"
//        case .bahah:     return "Bahah"
        }
    }

    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .arrass:     return .init(latitude: 25.869636, longitude: 43.498475)
        case .qassim:     return .init(latitude: 26.100814, longitude: 43.860099)
        case .riyadh:     return .init(latitude: 24.7136, longitude: 46.6753)
        case .almadinah:  return .init(latitude: 24.467857, longitude: 39.614242)
        case .meccah:     return .init(latitude: 21.409623, longitude: 39.816230)
        case .tabuk:      return .init(latitude: 28.400551, longitude: 36.557152)
//        case .najran:     return .init(latitude: 0.0, longitude: 0.0)
//        case .jazan:      return .init(latitude: 0.0, longitude: 0.0)
//        case .hail:       return .init(latitude: 0.0, longitude: 0.0)
//        case .asir:       return .init(latitude: 0.0, longitude: 0.0)
//        case .jawf:       return .init(latitude: 0.0, longitude: 0.0)
//        case .bahah:      return .init(latitude: 0.0, longitude: 0.0)
        }
    }

    var extraZoomLevel: MKCoordinateSpan {
        switch self {
        case .arrass:     return .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        case .qassim:     return .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        case .riyadh:     return .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        case .almadinah:  return .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        case .meccah:     return .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        case .tabuk:      return .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
//        case .najran:     return .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        case .jazan:      return .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        case .hail:       return .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        case .asir:       return .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        case .jawf:       return .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        case .bahah:      return .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
        }
    }

    var zoomLevel: MKCoordinateSpan {
        switch self {
        case .arrass:     return .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        case .qassim:     return .init(latitudeDelta: 1.0, longitudeDelta: 1.0)
        case .riyadh:     return .init(latitudeDelta: 0.3, longitudeDelta: 0.3)
        case .almadinah:  return .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
        case .meccah:     return .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
        case .tabuk:      return .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        case .najran:     return .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        case .jazan:      return .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        case .hail:       return .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        case .asir:       return .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        case .jawf:       return .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        case .bahah:      return .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
        }
    }
}

struct RealEstate: Codable, Equatable, Identifiable {
    static func == (lhs: RealEstate, rhs: RealEstate) -> Bool {
        return lhs.id == rhs.id
    }

    var id = UUID().uuidString
    var images: [String] = []
    var description: String = ""
    var beds: Int = 0
    var baths: Int = 0
    var livingRooms: Int = 0
    var space: Int = 0
    var ovens: Int = 0
    var fridges: Int = 0
    var microwaves: Int = 0
    var airConditions: Int = 0

    var isSmart:     Bool = false
    var hasWiFi:     Bool = false
    var hasPool:     Bool = false
    var hasElevator: Bool = false
    var hasGym:      Bool = false

    var age: Int = 0

    var location: CLLocationCoordinate2D = .init(latitude: 0.0, longitude: 0.0)

    var saleCategory           : SaleCategory = .rent
    var city                  : City = .arrass
    var type                  : RealEstateType = .apartment
    var offer                 : OfferType      = .yearly
    var isAvailable            : Bool = true
    var price                 : Int = 0
    var videoUrlString         : String = ""
}

extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let longitude = try container.decode(CLLocationDegrees.self)
        let latitude = try container.decode(CLLocationDegrees.self)
        self.init(latitude: latitude, longitude: longitude)
    }
}

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
