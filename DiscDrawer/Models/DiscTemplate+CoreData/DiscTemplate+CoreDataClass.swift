//
//  DiscTemplate+CoreDataClass.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/13/23.
//
//

import Foundation
import CoreData

@objc(DiscTemplate)
public class DiscTemplate: NSManagedObject, Decodable {

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case manufacturer = "brand"
        case type = "category"
        case speed = "speed"
        case glide = "glide"
        case turn = "turn"
        case fade = "fade"
        case stability = "stability"
        case flightChartUrl = "pic"
    }

    required public convenience init(from decoder: Decoder) throws {

        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            print("Failed to assign context")
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.manufacturer = try container.decode(String.self, forKey: .manufacturer)
        self.speed = try container.decode(String.self, forKey: .speed)
        self.glide = try container.decode(String.self, forKey: .glide)
        self.turn = try container.decode(String.self, forKey: .turn)
        self.fade = try container.decode(String.self, forKey: .fade)
        self.stability = try container.decode(String.self, forKey: .stability)
        self.flightChartUrl = try container.decode(String.self, forKey: .flightChartUrl)

        // Adjust some cases of type
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "Hybrid Driver", "Distance Driver":
            self.type = "Driver"
        case "Control Driver":
            self.type = "Fairway"
        case "Approach":
            self.type = "Putter"
        default:
            self.type = type
        }
    }
}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
