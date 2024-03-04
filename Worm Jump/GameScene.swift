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
    var terrain: SKSpriteNode!
    var gameOverBanner: SKSpriteNode!
    var homeButton: SKShapeNode!
    var restartButton: SKShapeNode!
    var isHalfed = false
    var gameSpeed: CGFloat = 4
    
    
    // Function called when the scene is presented in a view
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(named: "sky")!
 
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
        grass.name = "grass"
        addChild(grass)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        
        
        makeObstacleWatcher()
        spawnObstacle()
        spawnPuddle()
        
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
        makeTerrainWatcher()
        spawnTerrain()
        
        
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
        
        
        //increase games speed every 10 seconds
        let increaseSpeedAction = SKAction.run {
            self.increaseGameSpeed()
        }

//        let wait = SKAction.wait(forDuration: 1)
//        let sequence = SKAction.sequence([increaseSpeedAction, wait])
//        let repeatSequence = SKAction.repeat(sequence, count: 20)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.run(increaseSpeedAction)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.run(increaseSpeedAction)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            self.run(increaseSpeedAction)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            self.run(increaseSpeedAction)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 25) {
            self.run(increaseSpeedAction)
        }
        
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
        // specify which other physics bodies the player should notify upon contact (here, obstacles)
        player.physicsBody?.contactTestBitMask = 2
        // specify which categories of physics bodies the player should collide with (here: grass)
        player.physicsBody?.collisionBitMask = 1
        player.name = "player"
    }
    
    func increaseGameSpeed() {
        let newDuration = gameSpeed - 0.001
        
//        if let movingAction = self.terrain.action(forKey: "movingScene") {
//            self.terrain.removeAction(forKey: "movingScene")
//            let moveLeft = SKAction.moveBy(x: -1200, y: 0, duration: self.gameSpeed)
//            let remove = SKAction.removeFromParent()
//            let sequence = SKAction.sequence([moveLeft, remove])
//            self.terrain.run(sequence, withKey: "movingScene")
//        }
        for case let node as SKSpriteNode in children where node.name == "terrain" {
            if let movingAction = node.action(forKey: "movingScene") {
                let moveLeft = SKAction.moveBy(x: -1200, y: 0, duration: newDuration)
                let remove = SKAction.removeFromParent()
                let sequence = SKAction.sequence([moveLeft, remove])
                
                node.removeAction(forKey: "movingScene")
                node.run(sequence, withKey: "movingScene")
            }
        }
        gameSpeed -= 0.1
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
        obstacle.name = "obstacle"
        addChild(obstacle)
        
        
        let moveLeft = SKAction.moveBy(x: -1200, y: 0, duration: gameSpeed)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveLeft, remove])
        obstacle.run(sequence, withKey: "movingScene")
    }
    
    func spawnPuddle() {
        let randomBool = [true, true, true, true, false]
        let hideOrNot = randomBool[Int(arc4random_uniform(5))]
        let texture = SKTexture(imageNamed: "puddle2")
        let puddle = SKSpriteNode(texture: texture, size: CGSize(width: 130, height: 40))
        puddle.position = CGPoint(x: size.width + 280, y: grass.position.y + grass.frame.size.height / 2 + puddle.size.height / 2 - 20)
        puddle.physicsBody = SKPhysicsBody(circleOfRadius: puddle.size.width / 2)
        puddle.physicsBody?.isDynamic = false
        puddle.physicsBody?.affectedByGravity = false
        puddle.physicsBody?.categoryBitMask = 2
        puddle.physicsBody?.collisionBitMask = 0
        puddle.physicsBody?.contactTestBitMask = 1
        puddle.isHidden = hideOrNot
        puddle.name = "puddle"
        addChild(puddle)
        
        
        let moveLeft = SKAction.moveBy(x: -1200, y: 0, duration: gameSpeed)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveLeft, remove])
        puddle.run(sequence, withKey: "movingScene")
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
        
        terrain = SKSpriteNode(texture: image, size: CGSize(width: size.width, height: 320))
        terrain.position = CGPoint(x: size.width, y: grass.position.y)
        terrain.physicsBody = SKPhysicsBody(rectangleOf: terrain.size)
        terrain.physicsBody?.isDynamic = false
        terrain.physicsBody?.affectedByGravity = false
        terrain.physicsBody?.restitution = 0.0
        terrain.physicsBody?.categoryBitMask = 10
        terrain.physicsBody?.collisionBitMask = 0
        terrain.physicsBody?.contactTestBitMask = 8
        terrain.zPosition = -1
        terrain.name = "terrain"
        addChild(terrain)
        
        
        // Move terrain from its spawn position to the left side of the screen
        let moveLeft = SKAction.moveBy(x: -1200, y: 0, duration: gameSpeed)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveLeft, remove])
        terrain.run(sequence, withKey: "movingTerrain")
    }
    
    func spawnInitialTerrain() {
        let image = SKTexture(imageNamed: "terrain")
        let initialterrain = SKSpriteNode(texture: image, size: CGSize(width: size.width + 60, height: 320))
        initialterrain.position = CGPoint(x: 0, y: grass.position.y)
        initialterrain.physicsBody = SKPhysicsBody(rectangleOf: initialterrain.size)
        initialterrain.physicsBody?.isDynamic = false
        initialterrain.physicsBody?.affectedByGravity = false
        initialterrain.physicsBody?.categoryBitMask = 10
        initialterrain.physicsBody?.restitution = 0.0
        initialterrain.zPosition = -1
        addChild(initialterrain)
        
        let moveLeft = SKAction.moveBy(x: -1200, y: 0, duration: gameSpeed)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveLeft, remove])
        initialterrain.run(sequence)
    }
    
    func makeTerrainWatcher() {
        //making a 1x1 pixel at 0,0 to watch for collisions with terrain so i can respawn another terrain when it hits 0,0. this can allow for speeding up the terrain movement without changing the amount of space between each terrain spawn
        let terrainWatchPixel = SKShapeNode(rectOf: CGSize(width: 10, height: 1))
        terrainWatchPixel.fillColor = .clear
        terrainWatchPixel.strokeColor = .clear
        terrainWatchPixel.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
        terrainWatchPixel.physicsBody?.isDynamic = true
        terrainWatchPixel.physicsBody?.affectedByGravity = false
        terrainWatchPixel.position = CGPoint(x: -size.width / 2 + 5, y: -300)
        terrainWatchPixel.zPosition = 30
        terrainWatchPixel.physicsBody?.categoryBitMask = 8
        terrainWatchPixel.physicsBody?.contactTestBitMask = 10
        terrainWatchPixel.physicsBody?.collisionBitMask = 0
        terrainWatchPixel.name = "terrainWatchPixel"
        addChild(terrainWatchPixel)
    }
    func makeObstacleWatcher() {
        let obstacleWatchPixel = SKShapeNode(rectOf: CGSize(width: 1, height: 10))
        obstacleWatchPixel.fillColor = .red
        obstacleWatchPixel.strokeColor = .clear
        obstacleWatchPixel.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 10))
        obstacleWatchPixel.physicsBody?.isDynamic = true
        obstacleWatchPixel.physicsBody?.affectedByGravity = false
        obstacleWatchPixel.position = CGPoint(x: -size.width / 2, y: -120)
        obstacleWatchPixel.zPosition = 30
        obstacleWatchPixel.physicsBody?.categoryBitMask = 1
        obstacleWatchPixel.physicsBody?.contactTestBitMask = 2
        obstacleWatchPixel.physicsBody?.collisionBitMask = 0
        obstacleWatchPixel.name = "obstacleWatchPixel"
        addChild(obstacleWatchPixel)
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
        
//        if let nodeA = contact.bodyA.node {
//            print("Body A name: \(nodeA.name ?? "Unnamed")")
//        }
//            
//        if let nodeB = contact.bodyB.node {
//            print("Body B name: \(nodeB.name ?? "Unnamed")")
//        }
        
        
        // Check if the contact is between the player and the rock obstacle
        if contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "obstacle" {
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
        
        if contact.bodyA.node?.name == "terrainWatchPixel" && contact.bodyB.node?.name == "terrain" {
            spawnTerrain()
        }
        if contact.bodyA.node?.name == "terrain" && contact.bodyB.node?.name == "terrainWatchPixel" {
            spawnTerrain()
        }
        
        if contact.bodyA.node?.name == "obstacleWatchPixel" && contact.bodyB.node?.name == "obstacle" {
            print("terrain touched")
            spawnObstacle()
            spawnPuddle()
        }
    }
    
    func handleGameOver() {
        self.isPaused = true
        gameOverBanner.isHidden = false
        homeButton.isHidden = false
        restartButton.isHidden = false
    }
    
}
