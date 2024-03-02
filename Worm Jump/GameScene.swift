//
//  GameScene.swift
//  Worm Jump
//
//  Created by Isabelle Smith on 2/28/24.
//

import SpriteKit
import GameplayKit

// Define a new class GameScene which inherits from SKScene (SpriteKit scene) and conforms to SKPhysicsContactDelegate (for physics-related events)
class GameScene: SKScene, SKPhysicsContactDelegate {

    // Declare a variable to hold the player character (a sprite node)
    var player: SKSpriteNode!
    var grass: SKShapeNode!
    var gameOverBanner: SKSpriteNode!
    var homeButton: SKShapeNode!
    var restartButton: SKShapeNode!
    var isHalfed = false
    var firstTerrain = true
    
    
    // Function called when the scene is presented in a view
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(named: "sky")!
        
        // Set this scene as the delegate to handle physics-related contacts
        physicsWorld.contactDelegate = self
        
        createPlayer()
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
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        
        // Create a repeating action to spawn rocks
        let spawn = SKAction.run { [weak self] in
            self?.spawnObstacle()
        }
        let delay = SKAction.wait(forDuration: 1.5)
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnForever = SKAction.repeatForever(spawnThenDelay)
        run(spawnForever)
        
        //spawn clouds
        let spawnCloud = SKAction.run { [weak self] in
            self?.spawnClouds()
        }
        let delayCloud = SKAction.wait(forDuration: 5)
        let spawnThenDelayCloud = SKAction.sequence([spawnCloud, delayCloud])
        let spawnForeverCloud = SKAction.repeatForever(spawnThenDelayCloud)
        run(spawnForeverCloud)
        
        //spawn initial terrain
        spawnInitialTerrain()
        
        //spawn repeating terrain
        let spawnTerrain = SKAction.run { [weak self] in
            self?.spawnTerrain()
        }
        let delayTerrain = SKAction.wait(forDuration: 1.27)
        let spawnThenDelayTerrain = SKAction.sequence([spawnTerrain, delayTerrain])
        let spawnForeverTerrain = SKAction.repeatForever(spawnThenDelayTerrain)
        run(spawnForeverTerrain)
        
        // Create game over banner
        let bannerTexture = SKTexture(imageNamed: "gameover")
        gameOverBanner = SKSpriteNode(texture: bannerTexture, size: CGSize(width: 300, height: 300))
        gameOverBanner.position = CGPoint(x: 0, y: 0)
        gameOverBanner.zPosition = 12
        gameOverBanner.isHidden = true
        gameOverBanner.physicsBody = nil
        addChild(gameOverBanner)
        //make home button
        homeButton = SKShapeNode(rectOf: CGSize(width: 80, height: 80))
        homeButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 80))
        homeButton.fillColor = .clear
        homeButton.strokeColor = .clear
        homeButton.physicsBody?.isDynamic = false
        homeButton.physicsBody?.affectedByGravity = false
        homeButton.position = CGPoint(x: -55, y: -50)
        homeButton.zPosition = 15
        homeButton.name = "homeButton"
        homeButton.isHidden = true
        homeButton.physicsBody = nil
        addChild(homeButton)
        //make restart button
        restartButton = SKShapeNode(rectOf: CGSize(width: 80, height: 80))
        restartButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 80))
        restartButton.fillColor = .clear
        restartButton.strokeColor = .clear
        restartButton.physicsBody?.isDynamic = false
        restartButton.physicsBody?.affectedByGravity = false
        restartButton.position = CGPoint(x: 52, y: -50)
        restartButton.zPosition = 15
        restartButton.name = "restartButton"
        restartButton.isHidden = true
        restartButton.physicsBody = nil
        addChild(restartButton)
        
        
    }
    
    // Function to create the player character
    func createPlayer() {
        let playerTexture = SKTexture(imageNamed: "worm")
        player = SKSpriteNode(texture: playerTexture, size: CGSize(width: 80, height: 80))
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = .init(x: -100, y: 0)
        player.zPosition = 10
        addChild(player)
        // Create a physics body for the player with a rectangle of its size
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        // Allow the player to move due to physics simulation
        player.physicsBody?.isDynamic = true
        player.physicsBody?.restitution = 0.0
        
        // Assign a category bitmask to the player (used for collisions)
        player.physicsBody?.categoryBitMask = 1
        // Specify which other physics bodies the player should notify upon contact (here, obstacles)
        player.physicsBody?.contactTestBitMask = 2
        // Specify which categories of physics bodies the player should collide with (here: grass)
        player.physicsBody?.collisionBitMask = 1
    }
    
    func spawnObstacle() {
        let obstacles = ["rock1", "rock2", "rock3", "flower"]
        let randomImage = obstacles[Int(arc4random_uniform(4))]
        let randomObstacle = SKTexture(imageNamed: randomImage)
        let obstacle = SKSpriteNode(texture: randomObstacle, size: CGSize(width: 90, height: 80))
        obstacle.position = CGPoint(x: size.width + 20, y: grass.position.y + grass.frame.size.height / 2 + obstacle.size.height / 2 - 20)
        obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacle.size.width / 2)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.categoryBitMask = 2
        obstacle.physicsBody?.collisionBitMask = 0
        obstacle.physicsBody?.contactTestBitMask = 1
        addChild(obstacle)
        
        
        let moveLeft = SKAction.moveBy(x: -1200, y: 0, duration: 4)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveLeft, remove])
        obstacle.run(sequence)
    }
    
    func spawnClouds() {
        let heights = [300, 350, 400, 450, 460, 480, 500, 525, 540, 550]
        let randomHeight = heights[Int(arc4random_uniform(10))]
        let image = SKTexture(imageNamed: "cloud")
        let cloud = SKSpriteNode(texture: image, size: CGSize(width: 200, height: 200))
        cloud.position = CGPoint(x: size.width + 20, y: grass.position.y + CGFloat(randomHeight))
        cloud.physicsBody = SKPhysicsBody(rectangleOf: cloud.size)
        cloud.physicsBody?.isDynamic = false
        cloud.physicsBody?.affectedByGravity = false
        cloud.physicsBody?.categoryBitMask = 10
        cloud.zPosition = -1
        addChild(cloud)
        
        
        let moveLeft = SKAction.moveBy(x: -1200, y: 0, duration: 20)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveLeft, remove])
        cloud.run(sequence)
    }
    
    func spawnTerrain() {
        let image = SKTexture(imageNamed: "terrain")
        
        let terrain = SKSpriteNode(texture: image, size: CGSize(width: size.width, height: 320))
//        terrain.position = CGPoint(x: size.width, y: grass.position.y)
        terrain.position = CGPoint(x: firstTerrain ? 0 : size.width, y: grass.position.y)
        terrain.physicsBody = SKPhysicsBody(rectangleOf: terrain.size)
        terrain.physicsBody?.isDynamic = false
        terrain.physicsBody?.affectedByGravity = false
        terrain.physicsBody?.categoryBitMask = 10
        terrain.physicsBody?.restitution = 0.0
        terrain.zPosition = -1
        addChild(terrain)
        
        
        // Move terrain from its spawn position to the left side of the screen
        let moveLeft = SKAction.moveBy(x: -1200, y: 0, duration: 4)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveLeft, remove])
        terrain.run(sequence)
        firstTerrain = false
    }
    
    func spawnInitialTerrain() {
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
        
        let moveLeft = SKAction.moveBy(x: -1200, y: 0, duration: 4)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveLeft, remove])
        initialterrain.run(sequence)
    }
    
    
    // Function to make the worm jump
    func jump() {
        if (player.intersects(grass)) {
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 350))
        }
    }
    
    // Function called when a touch begins on the scene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (gameOverBanner.isHidden) {
            jump()
        }
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
            }        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Check if the contact is between the player and the rock obstacle
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2 {
            // Player collided with an obstacle
            if (isHalfed) {
                handleGameOver()
            } else {
                isHalfed = true
                if let playerNode = contact.bodyA.node as? SKSpriteNode {
                    playerNode.texture = SKTexture(imageNamed: "halfworm")
                    playerNode.size = CGSize(width: 55, height: 80)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                       // Excecute after 30 seconds
                        self.isHalfed = false
                        playerNode.texture = SKTexture(imageNamed: "worm")
                        playerNode.size = CGSize(width: 80, height: 80)
                    }
                }
            }
        }
    }
    
    func handleGameOver() {
        self.isPaused = true
        gameOverBanner.isHidden = false
        homeButton.isHidden = false
        restartButton.isHidden = false
    }
    
}
