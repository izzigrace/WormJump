//
//  GameViewController.swift
//  Worm Jump
//
//  Created by Isabelle Smith on 2/28/24.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreData

class GameViewController: UIViewController {
    
    var player: Player?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        //create a new Player object
        let newPlayer = Player(context: context)
        newPlayer.droplets = 0
        newPlayer.hatsOwned = []
        newPlayer.currentHat = "none"
        //save the context
        do {
            try context.save()
        } catch {
            print("Error saving player: \(error)")
        }
    
        // Fetch the Player object
        let playerFetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
        do {
            let players = try context.fetch(playerFetchRequest)
            if let player = players.first {
                
            } else {
                print("No player found")
            }
        } catch {
            print("Error fetching player: \(error)")
        }
        
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = MainMenuScene(size: view.bounds.size, player: player ?? newPlayer)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5) // Center the scene content
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
                
            // Present the scene
            view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
