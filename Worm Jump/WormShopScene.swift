//
//  WormShop.swift
//  Worm Jump
//
//  Created by Isabelle Smith on 3/4/24.
//

import Foundation
import SpriteKit
import GameplayKit
import CoreData

class WormShopScene: SKScene {
    var capButton: SKSpriteNode!
    var sproutButton: SKSpriteNode!
    var catEarsButton: SKSpriteNode!
    var bowButton: SKSpriteNode!
    var arrow: SKSpriteNode!
    var price: SKSpriteNode!
    var price2: SKSpriteNode!
    var price3: SKSpriteNode!
    var price4: SKSpriteNode!
    
    var player: Player // Store the player object
        
        init(size: CGSize, player: Player) {
            self.player = player
            super.init(size: size)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func didMove(to view: SKView) {
                
        // Fetching player droplets
        let playerDroplets = player.fetchPlayerDroplets()
        print("hi", playerDroplets)
        
        
        backgroundColor = UIColor(named: "shop")!
        
        
        //disable gravity for the whole scene
        physicsWorld.gravity = CGVector.zero

        let sproutTexture = SKTexture(imageNamed: "sproutbutton")
        sproutButton = SKSpriteNode(texture: sproutTexture, size: CGSize(width: 180, height: 120))
        sproutButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 180, height: 120))
        sproutButton.physicsBody?.isDynamic = false
        sproutButton.physicsBody?.affectedByGravity = false
        sproutButton.position = CGPoint(x: -95, y: 130)
        sproutButton.zPosition = -1
        sproutButton.name = "sproutButton"
        addChild(sproutButton)

        let bowTexture = SKTexture(imageNamed: "bowbutton")
        bowButton = SKSpriteNode(texture: bowTexture, size: CGSize(width: 180, height: 120))
        bowButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 180, height: 120))
        bowButton.physicsBody?.isDynamic = false
        bowButton.physicsBody?.affectedByGravity = false
        bowButton.position = CGPoint(x: 95, y: 130)
        bowButton.zPosition = -1
        bowButton.name = "bowButton"
        addChild(bowButton)

        let catearTexture = SKTexture(imageNamed: "catearbutton")
        catEarsButton = SKSpriteNode(texture: catearTexture, size: CGSize(width: 180, height: 120))
        catEarsButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 180, height: 120))
        catEarsButton.physicsBody?.isDynamic = false
        catEarsButton.physicsBody?.affectedByGravity = false
        catEarsButton.position = CGPoint(x: -95, y: -70)
        catEarsButton.zPosition = -1
        catEarsButton.name = "catEarsButton"
        addChild(catEarsButton)
        
        let capTexture = SKTexture(imageNamed: "capbutton")
        capButton = SKSpriteNode(texture: capTexture, size: CGSize(width: 180, height: 120))
        capButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 180, height: 120))
        capButton.physicsBody?.isDynamic = false
        capButton.physicsBody?.affectedByGravity = false
        capButton.position = CGPoint(x: 95, y: -70)
        capButton.zPosition = -1
        capButton.name = "capButton"
        addChild(capButton)
        
        let priceTexture = SKTexture(imageNamed: "50")
        price = SKSpriteNode(texture: priceTexture, size: CGSize(width: 60, height: 30))
        price.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 30))
        price.physicsBody?.isDynamic = false
        price.physicsBody?.affectedByGravity = false
        price.position = CGPoint(x: -95, y: 45)
        price.zPosition = 5
        price.name = "price"
        addChild(price)
        price2 = SKSpriteNode(texture: priceTexture, size: CGSize(width: 60, height: 30))
        price2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 30))
        price2.physicsBody?.isDynamic = false
        price2.physicsBody?.affectedByGravity = false
        price2.position = CGPoint(x: 95, y: 45)
        price2.zPosition = 5
        price2.name = "price2"
        addChild(price2)
        price3 = SKSpriteNode(texture: priceTexture, size: CGSize(width: 60, height: 30))
        price3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 30))
        price3.physicsBody?.isDynamic = false
        price3.physicsBody?.affectedByGravity = false
        price3.position = CGPoint(x: -95, y: -160)
        price3.zPosition = 5
        price3.name = "price3"
        addChild(price3)
        price4 = SKSpriteNode(texture: priceTexture, size: CGSize(width: 60, height: 30))
        price4.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 30))
        price4.physicsBody?.isDynamic = false
        price4.physicsBody?.affectedByGravity = false
        price4.position = CGPoint(x: 95, y: -160)
        price4.zPosition = 5
        price4.name = "price4"
        addChild(price4)
        
        
        //make xOutInstructions node
        let arrowTexture = SKTexture(imageNamed: "arrow")
        arrow = SKSpriteNode(texture: arrowTexture, size: CGSize(width: 30, height: 30))
        arrow.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30))
        arrow.physicsBody?.isDynamic = false
        arrow.physicsBody?.affectedByGravity = false
        arrow.position = CGPoint(x: -size.width / 2 + 40, y: size.height / 2 - 70)
        arrow.zPosition = 5
        arrow.name = "arrow"
        addChild(arrow)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Handle touches on the main menu buttons
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "arrow" {
                goToMenu()
            } else if touchedNode.name == "sproutButton" {
                
            } else if touchedNode.name == "bowButton" {
                
            } else if touchedNode.name == "catEarsButton" {
                
            } else if touchedNode.name == "capButton" {
                
            }
        }
    }
    
    func goToMenu() {
        if let view = self.view {
            let sceneSize = view.bounds.size
            let scene = MainMenuScene(size: view.bounds.size, player: player)
            scene.scaleMode = .aspectFill
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5) // Center the scene content
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene)
        }
    }
    
}
