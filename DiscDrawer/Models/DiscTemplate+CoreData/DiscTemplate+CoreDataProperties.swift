//
//  DiscTemplate+CoreDataProperties.swift
//  DiscDrawer
//
//  Created by Aguirre, Brian P. on 9/13/23.
//
//

import Foundation
import CoreData


extension DiscTemplate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiscTemplate> {
        return NSFetchRequest<DiscTemplate>(entityName: "DiscTemplate")
    }

    @NSManaged public var name: String?
    @NSManaged public var manufacturer: String?
    @NSManaged public var type: String?
    @NSManaged public var speed: String?
    @NSManaged public var glide: String?
    @NSManaged public var turn: String?
    @NSManaged public var fade: String?
    @NSManaged public var stability: String?
    @NSManaged public var flightChartUrl: String?
    
    // Convenience computed properties
    
    public var wrappedName: String {
        name ?? "Unknown name"
    }

    public var wrappedManufacturer: String {
        manufacturer ?? "Unknown manufacturer"
    }
    
    public var wrappedType: String {
        type ?? "Putter"
    }
    
    public var wrappedSpeed: String {
        speed ?? "?"
    }
    
    public var wrappedGlide: String {
        glide ?? "?"
    }
    
    public var wrappedTurn: String {
        turn ?? "?"
    }
    
    public var wrappedFade: String {
        fade ?? "?"
    }
    
    public var wrappedStability: String {
        stability ?? "Stable"
    }
}

extension DiscTemplate : Identifiable {

}
