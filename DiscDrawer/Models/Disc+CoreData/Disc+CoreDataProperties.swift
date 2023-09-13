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
    @NSManaged public var fade: Int16
    @NSManaged public var flightChartUrl: String?
    @NSManaged public var glide: Int16
    @NSManaged public var inBag: Bool
    @NSManaged public var manufacturer: String?
    @NSManaged public var name: String?
    @NSManaged public var plastic: String?
    @NSManaged public var speed: Int16
    @NSManaged public var stability: String?
    @NSManaged public var turn: Int16
    @NSManaged public var type: String?
    @NSManaged public var weight: Int16
    
    // Convenience computed properties
    
    public var wrappedName: String {
        name ?? "Unknown name"
    }

    public var wrappedManufacturer: String {
        manufacturer ?? "Unknown manufacturer"
    }
    
    public var wrappedPlastic: String {
        plastic ?? "Unknown plastic"
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
