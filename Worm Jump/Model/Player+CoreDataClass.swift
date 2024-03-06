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
    
    //fetch player droplets
    func fetchPlayerDroplets() -> Int16 {
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
        guard let currentHat = self.currentHat else {
            return nil
        }
        return currentHat
    }
    
    // update players droplets
    func updatePlayerDroplets(newDroplets: Int16) {
        self.droplets = Int16(newDroplets)
    }
    
    // add a hat to players list of hats
    func addHatToPlayer(hat: String) {
        var hatsArray = fetchPlayerHats()
        hatsArray.append(hat)
        self.hatsOwned = hatsArray
    }
    
    // update players current hat
    func updatePlayerCurrentHat(newHat: String) {
        self.currentHat = newHat
    }
}
