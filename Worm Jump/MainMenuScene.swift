//
//  MainMenuScene.swift
//  Worm Jump
//
//  Created by Isabelle Smith on 3/1/24.
//

import Foundation
import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {
    var startButton: SKSpriteNode!
    var shopButton: SKSpriteNode!
    var howToPlayButton: SKSpriteNode!
    var settingsButton: SKSpriteNode!
    var instructions: SKSpriteNode!
    var xOutInstructions: SKShapeNode!
    
    var player: Player //store the player object
    init(size: CGSize, player: Player) {
        self.player = player
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(named: "sky")!
        //disable gravity for the whole scene
        physicsWorld.gravity = CGVector.zero
        
        //make start button
        let startTexture = SKTexture(imageNamed: "start")
        startButton = SKSpriteNode(texture: startTexture, size: CGSize(width: 200, height: 100))
        startButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 120))
        startButton.physicsBody?.isDynamic = false
        startButton.physicsBody?.affectedByGravity = false
        startButton.position = CGPoint(x: 0, y: 100)
        startButton.zPosition = -1
        startButton.name = "startButton"
        addChild(startButton)
        
        //make shop button
        let shopTexture = SKTexture(imageNamed: "shop")
        shopButton = SKSpriteNode(texture: shopTexture, size: CGSize(width: 200, height: 50))
        shopButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 50))
        shopButton.physicsBody?.isDynamic = false
        shopButton.physicsBody?.affectedByGravity = false
        shopButton.position = CGPoint(x: 0, y: -20)
        shopButton.zPosition = -1
        shopButton.name = "shopButton"
        addChild(shopButton)
        
        //make howto button
        let howToTexture = SKTexture(imageNamed: "howto")
        howToPlayButton = SKSpriteNode(texture: howToTexture, size: CGSize(width: 200, height: 50))
        howToPlayButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 50))
        howToPlayButton.physicsBody?.isDynamic = false
        howToPlayButton.physicsBody?.affectedByGravity = false
        howToPlayButton.position = CGPoint(x: 0, y: -100)
        howToPlayButton.zPosition = -1
        howToPlayButton.name = "howToPlayButton"
        addChild(howToPlayButton)
        
        //make instructions node
        let instructionsTexture = SKTexture(imageNamed: "instructions")
        instructions = SKSpriteNode(texture: instructionsTexture, size: CGSize(width: 320, height: 480))
        instructions.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 300, height: 500))
        instructions.physicsBody?.isDynamic = false
        instructions.physicsBody?.affectedByGravity = false
        instructions.position = CGPoint(x: 0, y: 0)
        instructions.zPosition = 2
        instructions.isHidden = true
        addChild(instructions)
        
        //make xOutInstructions node
        xOutInstructions = SKShapeNode(rectOf: CGSize(width: 40, height: 40))
        xOutInstructions.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
        xOutInstructions.fillColor = .clear
        xOutInstructions.strokeColor = .clear
        xOutInstructions.physicsBody?.isDynamic = false
        xOutInstructions.physicsBody?.affectedByGravity = false
        xOutInstructions.position = CGPoint(x: -1, y: -191)
        xOutInstructions.zPosition = 5
        xOutInstructions.isHidden = true
        xOutInstructions.name = "xOutInstructions"
        addChild(xOutInstructions)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "startButton" {
                startGame()
            } else if touchedNode.name == "shopButton" {
                openShop()
            } else if touchedNode.name == "howToPlayButton" {
                instructions.isHidden = false
                xOutInstructions.isHidden = false
            } else if touchedNode.name == "xOutInstructions" {
                instructions.isHidden = true
                xOutInstructions.isHidden = true
            }
        }
    }
    
    func startGame() {
        if let view = self.view {
            let sceneSize = view.bounds.size
            let scene = GameScene(size: sceneSize, player: player)
            scene.scaleMode = .aspectFill
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5) // Center the scene content
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene)
        }
    }
    
    func openShop() {
        if let view = self.view {
            let scene = WormShopScene(size: view.bounds.size, player: player)
            scene.scaleMode = .aspectFill
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5) // Center the scene content
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene)
        }
    }
}
