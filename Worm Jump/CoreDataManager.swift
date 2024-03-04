////
////  CoreDataManager.swift
////  Worm Jump
////
////  Created by Isabelle Smith on 3/4/24.
////
//
//import Foundation
//import CoreData
//
//// player entity
//@objc(Player)
//public class Player: NSManagedObject {
//    //properties
//    @NSManaged public var droplets: Int16   //number of coins the player has (int16 ranges from -32,768 to 32,767 the higher ints have bigger range but i dont think my games needs to account for the possibility of more than 32,000 points)
//    @NSManaged public var name: String?  // name? do i need it
//    @NSManaged public var hatsOwned: [String] // Array of hat IDs or names owned by the player
//}
//
//
//extension Player {
//    //helper functions go here
//
//    func fetchPlayerHatsOwned(for player: Player) -> [String] {
//        return player.hatsOwned
//    }
//    func fetchPlayerDroplets(for player: Player) -> Int16 {
//        return player.droplets
//    }
//    func fetchPlayerCurrentHat(for player: Player) -> String {
//        return player.currentHat
//    }
//
//    
//}
//
//
//class CoreDataManager {
//    static let shared = CoreDataManager()
//
//    private init() {}
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "GameModel")
//        container.loadPersistentStores { (_, error) in
//            if let error = error {
//                fatalError("Failed to load persistent stores: \(error)")
//            }
//        }
//        return container
//    }()
//
//    var context: NSManagedObjectContext {
//        return persistentContainer.viewContext
//    }
//
//    // Function to fetch the player entity from Core Data
//    func fetchPlayer() -> Player? {
//        let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
//        do {
//            let players = try context.fetch(fetchRequest)
//            return players.first  // Return the first player found (if any)
//        } catch {
//            print("Error fetching player: \(error)")
//            return nil
//        }
//    }
//
//    // Function to save changes made to Core Data context
//    func saveContext() {
//        do {
//            try context.save()  // Save the changes to the Core Data context
//        } catch {
//            print("Error saving context: \(error)")
//        }
//    }
//}
