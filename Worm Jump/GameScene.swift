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
        
    }
    
    // Function to create the player character
    func createPlayer() {
        let playerTexture = SKTexture(imageNamed: "worm")
        player = SKSpriteNode(texture: playerTexture, size: CGSize(width: 80, height: 80))
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = .init(x: -100, y: 0)
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
        let obstacles = ["rock1", "rock2", "rock3"]
        let randomObstacle = SKTexture(imageNamed: obstacles[Int(arc4random_uniform(3))])
        let obstacle = SKSpriteNode(texture: randomObstacle, size: CGSize(width: 90, height: 90))
        obstacle.position = CGPoint(x: size.width + 20, y: grass.position.y + grass.frame.size.height / 2 + obstacle.size.height / 2 - 20)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
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
    
    
    // Function to make the worm jump
    func jump() {
        if (player.intersects(grass)) {
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 350))
        }
    }
    
    // Function called when a touch begins on the scene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        jump()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Check if the contact is between the player and the rock obstacle
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2 {
            // Player collided with an obstacle
            if let rock = contact.bodyB.node as? SKSpriteNode {
                // Remove the obstacle from the scene
                rock.removeFromParent()
            }
        } else if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1 {
            // Player collided with an obstacle
            if let rock = contact.bodyA.node as? SKSpriteNode {
                // Remove the obstacle from the scene
                rock.removeFromParent()
            }
        }
    }
    
}
