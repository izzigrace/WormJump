//
//  GameOver.swift
//  Worm Jump
//
//  Created by Isabelle Smith on 3/01/24.
//

import SpriteKit
import GameplayKit

class GameOverScene: SKScene, SKPhysicsContactDelegate {

    // Declare a variable to hold the player character (a sprite node)
    var grass: SKShapeNode!
    var gameOverBanner: SKSpriteNode!
    var homeButton: SKShapeNode!
    var restartButton: SKShapeNode!
    
    // Function called when the scene is presented in a view
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(named: "sky")!
        
        // Set this scene as the delegate to handle physics-related contacts
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        

        grass = SKShapeNode(rectOf: CGSize(width: size.width, height: 300))
        grass.fillColor = UIColor(named: "grass")!
        grass.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 300))
        grass.physicsBody?.isDynamic = false
        grass.physicsBody?.affectedByGravity = false
        grass.physicsBody?.restitution = 0.0
        // Calculate the position for the player's bottom at the bottom of the screen
        let bottomY = -size.height / 2 + grass.frame.size.height / 2
        grass.position = CGPoint(x: 0, y: bottomY)
        grass.zPosition = -1
        addChild(grass)
        
        let image = SKTexture(imageNamed: "terrain")
        let initialterrain = SKSpriteNode(texture: image, size: CGSize(width: size.width + 12, height: 320))
        initialterrain.position = CGPoint(x: size.width, y: grass.position.y)
        initialterrain.physicsBody = SKPhysicsBody(rectangleOf: initialterrain.size)
        initialterrain.physicsBody?.isDynamic = false
        initialterrain.physicsBody?.affectedByGravity = false
        initialterrain.physicsBody?.categoryBitMask = 10
        initialterrain.physicsBody?.restitution = 0.0
        initialterrain.zPosition = -1
        addChild(initialterrain)


        
        // Create game over banner
        let bannerTexture = SKTexture(imageNamed: "gameover")
        gameOverBanner = SKSpriteNode(texture: bannerTexture, size: CGSize(width: 300, height: 300))
        gameOverBanner.position = CGPoint(x: 0, y: 0)
        gameOverBanner.zPosition = 10
        gameOverBanner.isHidden = true
        addChild(gameOverBanner)
        //make home button
        homeButton = SKShapeNode(rectOf: CGSize(width: 80, height: 80))
        homeButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 80))
        homeButton.fillColor = .clear
        homeButton.strokeColor = .red
        homeButton.physicsBody?.isDynamic = false
        homeButton.physicsBody?.affectedByGravity = false
        homeButton.position = CGPoint(x: -50, y: -100)
        homeButton.zPosition = 15
        homeButton.isHidden = true
        homeButton.name = "homeButton"
        addChild(homeButton)
        //make restart button
        restartButton = SKShapeNode(rectOf: CGSize(width: 80, height: 80))
        restartButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 80))
        restartButton.fillColor = .clear
        restartButton.strokeColor = .red
        restartButton.physicsBody?.isDynamic = false
        restartButton.physicsBody?.affectedByGravity = false
        restartButton.position = CGPoint(x: 50, y: -100)
        restartButton.zPosition = 15
        restartButton.isHidden = true
        restartButton.name = "restartButton"
        addChild(restartButton)
        
    }
    
    
    
    

    
    // Function called when a touch begins on the scene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //handle touches on the home and restart buttons
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "homeButton" {
                if let view = self.view {
                    let sceneSize = view.bounds.size
                    let scene = MainMenuScene(size: sceneSize)
                    scene.scaleMode = .aspectFill
                    scene.anchorPoint = CGPoint(x: 0.5, y: 0.5) // Center the scene content
                    view.ignoresSiblingOrder = true
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.presentScene(scene)
                }
            } else if touchedNode.name == "restartButton" {
                if let view = self.view {
                    let sceneSize = view.bounds.size
                    let scene = GameScene(size: sceneSize)
                    scene.scaleMode = .aspectFill
                    scene.anchorPoint = CGPoint(x: 0.5, y: 0.5) // Center the scene content
                    view.ignoresSiblingOrder = true
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.presentScene(scene)
                }
            }
        }
    }
    
    
    
    
}
