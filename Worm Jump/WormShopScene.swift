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
    var droplets: SKLabelNode!
    var dropletIcon: SKSpriteNode!
    var buy: SKSpriteNode!
    var buyButton: SKShapeNode!
    var notEnoughDroplets: SKSpriteNode!
    var wear: SKSpriteNode!
    var wearButton: SKShapeNode!
    var takeOff: SKSpriteNode!
    var takeOffButton: SKShapeNode!
    var xOutButton: SKShapeNode!
    var clickedHat = ""
    
    var player: Player //store the player object
        
        init(size: CGSize, player: Player) {
            self.player = player
            super.init(size: size)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func didMove(to view: SKView) {
        
        //giving user 500 droplets to spend at the shop, in case someone is testing my app and wants to see all the features without having to collect 50 droplets for a hat :)
        player.updatePlayerDroplets(newDroplets: 500)
        
        backgroundColor = UIColor(named: "shop")!
        //disable gravity for the whole scene
        physicsWorld.gravity = CGVector.zero
        
        //displaying the players amount of droplets
        droplets = SKLabelNode(fontNamed: "Arial")
        droplets.text = "\(player.fetchPlayerDroplets())"
        droplets.fontSize = 24
        droplets.position = CGPoint(x: size.width / 2 - 70, y: size.height / 2 - 80)
        addChild(droplets)
        let dropletTexture = SKTexture(imageNamed: "whitedrop")
        dropletIcon = SKSpriteNode(texture: dropletTexture, size: CGSize(width: 30, height: 30))
        dropletIcon.position = CGPoint(x: size.width / 2 - 30, y: size.height / 2 - 70)
        addChild(dropletIcon)

        //add sprout hat button
        let sproutTexture = SKTexture(imageNamed: "sproutbutton")
        sproutButton = SKSpriteNode(texture: sproutTexture, size: CGSize(width: 180, height: 120))
        sproutButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 180, height: 120))
        sproutButton.physicsBody?.isDynamic = false
        sproutButton.physicsBody?.affectedByGravity = false
        sproutButton.position = CGPoint(x: -95, y: 130)
        sproutButton.zPosition = -1
        sproutButton.name = "sproutButton"
        addChild(sproutButton)

        //add bow hat button
        let bowTexture = SKTexture(imageNamed: "bowbutton")
        bowButton = SKSpriteNode(texture: bowTexture, size: CGSize(width: 180, height: 120))
        bowButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 180, height: 120))
        bowButton.physicsBody?.isDynamic = false
        bowButton.physicsBody?.affectedByGravity = false
        bowButton.position = CGPoint(x: 95, y: 130)
        bowButton.zPosition = -1
        bowButton.name = "bowButton"
        addChild(bowButton)

        //add cat ear hat button
        let catearTexture = SKTexture(imageNamed: "catearbutton")
        catEarsButton = SKSpriteNode(texture: catearTexture, size: CGSize(width: 180, height: 120))
        catEarsButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 180, height: 120))
        catEarsButton.physicsBody?.isDynamic = false
        catEarsButton.physicsBody?.affectedByGravity = false
        catEarsButton.position = CGPoint(x: -95, y: -70)
        catEarsButton.zPosition = -1
        catEarsButton.name = "catEarsButton"
        addChild(catEarsButton)
        
        //add cap hat button
        let capTexture = SKTexture(imageNamed: "capbutton")
        capButton = SKSpriteNode(texture: capTexture, size: CGSize(width: 180, height: 120))
        capButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 180, height: 120))
        capButton.physicsBody?.isDynamic = false
        capButton.physicsBody?.affectedByGravity = false
        capButton.position = CGPoint(x: 95, y: -70)
        capButton.zPosition = -1
        capButton.name = "capButton"
        addChild(capButton)
        
        //create buy banner and button to buy
        let buyTexture = SKTexture(imageNamed: "buy")
        buy = SKSpriteNode(texture: buyTexture, size: CGSize(width: 280, height: 380))
        buy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 300))
        buy.physicsBody?.isDynamic = false
        buy.physicsBody?.affectedByGravity = false
        buy.position = CGPoint(x: 0, y: 20)
        buy.zPosition = 100
        buy.name = "buy"
        buy.isHidden = true
        addChild(buy)
        buyButton = SKShapeNode(rectOf: CGSize(width: 170, height: 75))
        buyButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
        buyButton.fillColor = .clear
        buyButton.strokeColor = .clear
        buyButton.physicsBody?.isDynamic = false
        buyButton.physicsBody?.affectedByGravity = false
        buyButton.position = CGPoint(x: 0, y: -10)
        buyButton.zPosition = 102
        buyButton.name = "buyButton"
        buyButton.isHidden = true
        addChild(buyButton)
        //create not enough droplets message
        let notEnoughTexture = SKTexture(imageNamed: "notenoughdroplets")
        notEnoughDroplets = SKSpriteNode(texture: notEnoughTexture, size: CGSize(width: 190, height: 130))
        notEnoughDroplets.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 300))
        notEnoughDroplets.physicsBody?.isDynamic = false
        notEnoughDroplets.physicsBody?.affectedByGravity = false
        notEnoughDroplets.position = CGPoint(x: 0, y: 100)
        notEnoughDroplets.zPosition = 102
        notEnoughDroplets.name = "notEnoughDroplets"
        notEnoughDroplets.isHidden = true
        addChild(notEnoughDroplets)
        
        //create do you want to wear? banner and button to put on
        let wearTexture = SKTexture(imageNamed: "wear")
        wear = SKSpriteNode(texture: wearTexture, size: CGSize(width: 280, height: 380))
        wear.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 300))
        wear.physicsBody?.isDynamic = false
        wear.physicsBody?.affectedByGravity = false
        wear.position = CGPoint(x: 0, y: 20)
        wear.zPosition = 200
        wear.name = "wear"
        wear.isHidden = true
        addChild(wear)
        wearButton = SKShapeNode(rectOf: CGSize(width: 170, height: 75))
        wearButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
        wearButton.fillColor = .clear
        wearButton.strokeColor = .clear
        wearButton.physicsBody?.isDynamic = false
        wearButton.physicsBody?.affectedByGravity = false
        wearButton.position = CGPoint(x: 0, y: -10)
        wearButton.zPosition = 201
        wearButton.name = "wearButton"
        wearButton.isHidden = true
        addChild(wearButton)
        
        //create do you want to take off? banner and button to take off
        let takeOffTexture = SKTexture(imageNamed: "takeoff")
        takeOff = SKSpriteNode(texture: takeOffTexture, size: CGSize(width: 280, height: 380))
        takeOff.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 300))
        takeOff.physicsBody?.isDynamic = false
        takeOff.physicsBody?.affectedByGravity = false
        takeOff.position = CGPoint(x: 0, y: 20)
        takeOff.zPosition = 300
        takeOff.name = "takeOff"
        takeOff.isHidden = true
        addChild(takeOff)
        takeOffButton = SKShapeNode(rectOf: CGSize(width: 170, height: 75))
        takeOffButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
        takeOffButton.fillColor = .clear
        takeOffButton.strokeColor = .clear
        takeOffButton.physicsBody?.isDynamic = false
        takeOffButton.physicsBody?.affectedByGravity = false
        takeOffButton.position = CGPoint(x: 0, y: -10)
        takeOffButton.zPosition = 301
        takeOffButton.name = "takeOffButton"
        takeOffButton.isHidden = true
        addChild(takeOffButton)
        
        
        //create button to close out of any banner
        xOutButton = SKShapeNode(rectOf: CGSize(width: 40, height: 40))
        xOutButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
        xOutButton.fillColor = .clear
        xOutButton.strokeColor = .clear
        xOutButton.physicsBody?.isDynamic = false
        xOutButton.physicsBody?.affectedByGravity = false
        xOutButton.position = CGPoint(x: 3, y: -103)
        xOutButton.zPosition = 500
        xOutButton.name = "xOutButton"
        xOutButton.isHidden = true
        addChild(xOutButton)
        
        //conditionally show the price for each hat (if the player hasnt bought it)
        let playersHats = player.fetchPlayerHats()
        let showPrice = playersHats.contains("sprout") ? true : false
        let priceTexture = SKTexture(imageNamed: "50")
        price = SKSpriteNode(texture: priceTexture, size: CGSize(width: 60, height: 30))
        price.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 30))
        price.physicsBody?.isDynamic = false
        price.physicsBody?.affectedByGravity = false
        price.position = CGPoint(x: -95, y: 45)
        price.zPosition = 5
        price.name = "price"
        price.isHidden = showPrice
        addChild(price)
        let showPrice2 = playersHats.contains("bow") ? true : false
        price2 = SKSpriteNode(texture: priceTexture, size: CGSize(width: 60, height: 30))
        price2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 30))
        price2.physicsBody?.isDynamic = false
        price2.physicsBody?.affectedByGravity = false
        price2.position = CGPoint(x: 95, y: 45)
        price2.zPosition = 5
        price2.name = "price2"
        price2.isHidden = showPrice2
        addChild(price2)
        let showPrice3 = playersHats.contains("catears") ? true : false
        price3 = SKSpriteNode(texture: priceTexture, size: CGSize(width: 60, height: 30))
        price3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 30))
        price3.physicsBody?.isDynamic = false
        price3.physicsBody?.affectedByGravity = false
        price3.position = CGPoint(x: -95, y: -160)
        price3.zPosition = 5
        price3.name = "price3"
        price3.isHidden = showPrice3
        addChild(price3)
        let showPrice4 = playersHats.contains("cap") ? true : false
        price4 = SKSpriteNode(texture: priceTexture, size: CGSize(width: 60, height: 30))
        price4.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 30))
        price4.physicsBody?.isDynamic = false
        price4.physicsBody?.affectedByGravity = false
        price4.position = CGPoint(x: 95, y: -160)
        price4.zPosition = 5
        price4.name = "price4"
        price4.isHidden = showPrice4
        addChild(price4)
        
        
        //make arrow to leave back to menu
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
            
            let ownedHats = player.fetchPlayerHats()
            let currentHat = player.fetchPlayerCurrentHat()
            
            if touchedNode.name == "arrow" {
                goToMenu()
            } else if touchedNode.name == "sproutButton" {
                clickedHat = "sprout"
                if ownedHats.contains("sprout") {
                    if currentHat == "sprout" {
                        takeOff.isHidden = false
                        takeOffButton.isHidden = false
                        xOutButton.isHidden = false
                    } else {
                        wear.isHidden = false
                        wearButton.isHidden = false
                        xOutButton.isHidden = false
                    }
                } else {
                    buy.isHidden = false
                    buyButton.isHidden = false
                    xOutButton.isHidden = false
                }
            } else if touchedNode.name == "bowButton" {
                clickedHat = "bow"
                if ownedHats.contains("bow") {
                    if currentHat == "bow" {
                        takeOff.isHidden = false
                        takeOffButton.isHidden = false
                        xOutButton.isHidden = false
                    } else {
                        wear.isHidden = false
                        wearButton.isHidden = false
                        xOutButton.isHidden = false
                    }
                } else {
                    buy.isHidden = false
                    buyButton.isHidden = false
                    xOutButton.isHidden = false
                }
            } else if touchedNode.name == "catEarsButton" {
                clickedHat = "catears"
                if ownedHats.contains("catears") {
                    if currentHat == "catears" {
                        takeOff.isHidden = false
                        takeOffButton.isHidden = false
                        xOutButton.isHidden = false
                    } else {
                        wear.isHidden = false
                        wearButton.isHidden = false
                        xOutButton.isHidden = false
                    }
                } else {
                    buy.isHidden = false
                    buyButton.isHidden = false
                    xOutButton.isHidden = false
                }
            } else if touchedNode.name == "capButton" {
                clickedHat = "cap"
                if ownedHats.contains("cap") {
                    if currentHat == "cap" {
                        takeOff.isHidden = false
                        takeOffButton.isHidden = false
                        xOutButton.isHidden = false
                    } else {
                        wear.isHidden = false
                        wearButton.isHidden = false
                        xOutButton.isHidden = false
                    }
                } else {
                    buy.isHidden = false
                    buyButton.isHidden = false
                    xOutButton.isHidden = false
                }
            } else if touchedNode.name == "xOutButton" {
                buy.isHidden = true
                buyButton.isHidden = true
                wear.isHidden = true
                wearButton.isHidden = true
                takeOff.isHidden = true
                takeOffButton.isHidden = true
                xOutButton.isHidden = true
            } else if touchedNode.name == "buyButton" {
                let playerCurrency = player.fetchPlayerDroplets()
                if (playerCurrency >= 50) {
                    let newCurrency = playerCurrency - 50
                    player.addHatToPlayer(hat: clickedHat)
                    player.updatePlayerDroplets(newDroplets: newCurrency)
                    droplets.text = "\(player.fetchPlayerDroplets())"
                    wear.isHidden = false
                    wearButton.isHidden = false
                    xOutButton.isHidden = false
                    buy.isHidden = true
                    buyButton.isHidden = true
                    if (clickedHat == "sprout") {
                        price.isHidden = true
                    }
                    if (clickedHat == "bow") {
                        price2.isHidden = true
                    }
                    if (clickedHat == "catears") {
                        price3.isHidden = true
                    }
                    if (clickedHat == "cap") {
                        price4.isHidden = true
                    }
                } else {
                    notEnoughDroplets.isHidden = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.notEnoughDroplets.isHidden = true
                    }
                }
            } else if touchedNode.name == "wearButton" {
                player.updatePlayerCurrentHat(newHat: clickedHat)
                wear.isHidden = true
                wearButton.isHidden = true
                xOutButton.isHidden = true
            }
            else if touchedNode.name == "takeOffButton" {
                player.updatePlayerCurrentHat(newHat: "none")
                takeOff.isHidden = true
                takeOffButton.isHidden = true
                xOutButton.isHidden = true
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
