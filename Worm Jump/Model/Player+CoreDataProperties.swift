//
//  Player+CoreDataProperties.swift
//  Worm Jump
//
//  Created by Isabelle Smith on 3/4/24.
//
// dont change this file for now

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var hatsOwned: [String]?
    @NSManaged public var droplets: Int16
    @NSManaged public var currentHat: String?

}

extension Player : Identifiable {

}
