//
//  Disc+CoreDataProperties.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/13/23.
//
//

import Foundation
import CoreData


extension Disc {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Disc> {
        return NSFetchRequest<Disc>(entityName: "Disc")
    }

    @NSManaged public var condition: String?
    @NSManaged public var fade: Double
    @NSManaged public var flightChartUrl: String?
    @NSManaged public var glide: Double
    @NSManaged public var imageData: Data?
    @NSManaged public var inBag: Bool
    @NSManaged public var manufacturer: String?
    @NSManaged public var name: String?
    @NSManaged public var plastic: String?
    @NSManaged public var speed: Double
    @NSManaged public var stability: String?
    @NSManaged public var turn: Double
    @NSManaged public var type: String?
    @NSManaged public var weight: Int16
    
    // Convenience computed properties
    
    public var wrappedName: String {
        name ?? "N/A"
    }

    public var wrappedManufacturer: String {
        if manufacturer == nil {
            return "N/A"
        } else if manufacturer == "" {
            return "N/A"
        } else {
            return manufacturer!
        }
    }
    
    public var wrappedPlastic: String {
        if plastic == nil {
            return "N/A"
        } else if plastic == "" {
            return "N/A"
        } else {
            return plastic!
        }
    }
    
    public var wrappedType: String {
        type ?? "Putter"
    }
    
    public var wrappedCondition: String {
        condition ?? "Great"
    }
    
    public var wrappedStability: String {
        stability ?? "Stable"
    }
}

extension Disc : Identifiable {

}
