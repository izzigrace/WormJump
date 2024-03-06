//
//  Player+CoreDataClass.swift
//  Worm Jump
//
//  Created by Isabelle Smith on 3/4/24.
//
// create helper functions here

import Foundation
import CoreData

@objc(Player)
public class Player: NSManagedObject {
    
    //fetch player points
    func fetchPlayerDroplets() -> Int16 {
        // Assuming droplets is an attribute in the Player entity
        return self.droplets ?? 0
    }
    
    //fetch players array of hats they own
    func fetchPlayerHats() -> [String] {
        guard let hatsOwnedArray = self.hatsOwned else {
            return []
        }
        return hatsOwnedArray
    }
    
    // fetch players current hat
    func fetchPlayerCurrentHat() -> String? {
        // Assuming currentHat is an attribute in the Player entity
        guard let currentHat = self.currentHat else {
            return nil
        }
        return currentHat
    }
    
    // update players points
    func updatePlayerDroplets(newDroplets: Int) {
        // Assuming points is an attribute in the Player entity
        self.droplets = Int16(newDroplets)
    }
    
    // add a hat to players list of hats
    func addHatToPlayer(hat: String) {
        // Assuming hatsOwned is an attribute in the Player entity, stored as a string
        var hatsArray = fetchPlayerHats()
        hatsArray.append(hat)
        self.hatsOwned = hatsArray
    }
    
    // update players current hat
    func updatePlayerCurrentHat(newHat: String) {
        // Assuming currentHat is an attribute in the Player entity
        self.currentHat = newHat
    }
}
