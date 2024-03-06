//
//  GameScene.swift
//  Worm Jump
//
//  Created by Isabelle Smith on 2/28/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var playerSprite: SKSpriteNode!
    var grass: SKShapeNode!
    var terrain: SKSpriteNode!
    var gameOverBanner: SKSpriteNode!
    var homeButton: SKShapeNode!
    var restartButton: SKShapeNode!
    var isHalfed = false
    var gameSpeed: CGFloat = 4
    var location: CGPoint?
    var splash: SKSpriteNode!
    var halfSplash: SKSpriteNode!
    var droplets: SKLabelNode!
    var dropletIcon: SKSpriteNode!
    var hatNode: SKSpriteNode!
    var wormTexture = SKTexture(imageNamed: "worm")
  
    var currentHat = "none"
    
    var player: Player //store the player object
    init(size: CGSize, player: Player) {
        self.player = player
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //function called when the scene is presented in a view
    override func didMove(to view: SKView) {
        
        backgroundColor = UIColor(named: "sky")!
 
        physicsWorld.contactDelegate = self
        
        //setting the texture for player to use depending on which hat (if any) is selected
        currentHat = player.fetchPlayerCurrentHat()!
        if currentHat == "none" {
            wormTexture = SKTexture(imageNamed: "worm")
        }
        if currentHat == "cap" {
            wormTexture = SKTexture(imageNamed: "wormcap")
        }
        if currentHat == "bow" {
            wormTexture = SKTexture(imageNamed: "wormbow")
        }
        if currentHat == "sprout" {
            wormTexture = SKTexture(imageNamed: "wormsprout")
        }
        if currentHat == "catears" {
            wormTexture = SKTexture(imageNamed: "wormcatears")
        }
        
        createPlayer()
        //making the "grass", a square that wont move like the terrain or obstacles, but stay in place for the player to jump on
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
        
        //setting worlds gravity
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        
        //display running count of collected droplets
        droplets = SKLabelNode(fontNamed: "Arial")
        droplets.text = "\(player.fetchPlayerDroplets())"
        droplets.fontSize = 24
        droplets.position = CGPoint(x: size.width / 2 - 70, y: size.height / 2 - 80)
        addChild(droplets)
        let dropletTexture = SKTexture(imageNamed: "whitedrop")
        dropletIcon = SKSpriteNode(texture: dropletTexture, size: CGSize(width: 30, height: 30))
        dropletIcon.position = CGPoint(x: size.width / 2 - 30, y: size.height / 2 - 70)
        addChild(dropletIcon)
        
        
        makeObstacleWatcher()
        spawnObstacle()
        spawnPuddle()
        
        //spawn clouds repeatedly
        let spawnCloud = SKAction.run { [weak self] in
            self?.spawnClouds()
        }
        let delayCloud = SKAction.wait(forDuration: 5)
        let spawnThenDelayCloud = SKAction.sequence([spawnCloud, delayCloud])
        let spawnForeverCloud = SKAction.repeatForever(spawnThenDelayCloud)
        run(spawnForeverCloud)
        
        //spawn terrain
        spawnInitialTerrain()
        makeTerrainWatcher()
        spawnTerrain()
        
        //create splash that shows when player splashes in puddle, one for when the worm is full length and one for when the worm is halfed
        let splashTexture = SKTexture(imageNamed: "splash")
        splash = SKSpriteNode(texture: splashTexture, size: CGSize(width: 95, height: 80))
        splash.position = .init(x: -100, y: -95)
        splash.zPosition = 20
        splash.physicsBody = nil
        addChild(splash)
        splash.isHidden = true
        let halfSplashTexture = SKTexture(imageNamed: "halfsplash")
        halfSplash = SKSpriteNode(texture: halfSplashTexture, size: CGSize(width: 100, height: 80))
        halfSplash.position = .init(x: -110, y: -95)
        halfSplash.zPosition = 18
        halfSplash.physicsBody = nil
        addChild(halfSplash)
        halfSplash.isHidden = true
        
        
        //create game over banner with buttons to restart the game or return to home screen
        let bannerTexture = SKTexture(imageNamed: "gameover")
        gameOverBanner = SKSpriteNode(texture: bannerTexture, size: CGSize(width: 300, height: 300))
        gameOverBanner.position = CGPoint(x: 0, y: 0)
        gameOverBanner.zPosition = 50
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
        homeButton.zPosition = 100
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
        restartButton.zPosition = 100
        restartButton.name = "restartButton"
        restartButton.isHidden = true
        restartButton.physicsBody = nil
        addChild(restartButton)
        
        
        //increase games speed every 10 seconds - this will be implemented better in the future, but not including this at the moment
//        let increaseSpeedAction = SKAction.run {
//            self.increaseGameSpeed()
//        }
        
//        let wait = SKAction.wait(forDuration: 1)
//        let sequence = SKAction.sequence([increaseSpeedAction, wait])
//        let repeatSequence = SKAction.repeat(sequence, count: 20)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.run(repeatSequence)
//        }
        
    }
    
    //function to create the player character
    func createPlayer() {
        playerSprite = SKSpriteNode(texture: wormTexture, size: CGSize(width: 80, height: 80))
        playerSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playerSprite.position = .init(x: -100, y: 0)
        playerSprite.zPosition = 10
        addChild(playerSprite)
        //create a physics body for the player with a rectangle of its size
        playerSprite.physicsBody = SKPhysicsBody(rectangleOf: playerSprite.size)
        //allow the player to move due to physics simulation
        playerSprite.physicsBody?.isDynamic = true
        playerSprite.physicsBody?.restitution = 0.0
        
        //assign a category bitmask to the player (used for collisions)
        playerSprite.physicsBody?.categoryBitMask = 1
        //specify which other physics bodies the player should notify upon contact (here, obstacles)
        playerSprite.physicsBody?.contactTestBitMask = 2
        //specify which categories of physics bodies the player should collide with (here, grass)
        playerSprite.physicsBody?.collisionBitMask = 1
        playerSprite.name = "player"
    }
    
    //not being used at the moment
    func increaseGameSpeed() {
        let newDuration = gameSpeed - 0.001
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
    
    //spawn a randomly chosen obstacle and move it across the screen, then remove it
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
    
    //spawn a puddle with a random isHidden value to make them randomly occuring, and move it across the screen, then remove it
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
    
    //spawn clouds, move across screen, remove
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
    
    //spawn terrain, move across the screen, then remove
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
    
    //spawn the first bit of terrain when game is started, move across the screen then remove
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
    
    //making a shape node to watch for collisions with terrain so i can respawn another terrain when it hits 0,0. this can hopefully allow for speeding up the terrain movement without changing the amount of space between each terrain spawn
    func makeTerrainWatcher() {
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
    //making a shape node atto watch for collisions with obstacles so i can respawn another obstacle when it hits the end of the screen
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
    
    
    //function to make the worm jump
    func jump() {
        if (playerSprite.intersects(grass)) {
            playerSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 350))
        }
    }
    
    //function called when a touch begins on the scene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //handle touches on the home and restart buttons
        for touch in touches {
            location = touch.location(in: self)
            let touchedNode = atPoint(location!)
            
            if touchedNode.name == "homeButton" {
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
            } else if touchedNode.name == "restartButton" {
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
            }        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let initialTouchPosition = self.location else {
            return
        }

        // check for swipe down, if no swipe down occured call jump function. else, if swipe down occured while player is in contact with a puddle, display a splash or half splash depending on if worm if halfed, for 0.15 seconds. and also increase the players droplet count by one
        if let touch = touches.first {
            let finalTouchPosition = touch.location(in: self)
            let deltaY = finalTouchPosition.y - initialTouchPosition.y

            if abs(deltaY) < 10 {
                if (gameOverBanner.isHidden) {
                    jump()
                }
            } else if deltaY < -50 {
                if let playerNode = playerSprite {
                    let playerBody = playerNode.physicsBody
                    if let contactedBodies = playerBody?.allContactedBodies() {
                        for contactedBody in contactedBodies {
                            if let contactedNode = contactedBody.node {
                                if contactedNode.name == "puddle" {
                                    let newPlayerDroplets = player.fetchPlayerDroplets() + 1
                                    player.updatePlayerDroplets(newDroplets: newPlayerDroplets)
                                    if isHalfed {
                                        halfSplash.isHidden = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            self.halfSplash.isHidden = true
                                        }
                                    } else {
                                        splash.isHidden = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            self.splash.isHidden = true
                                        }
                                    }
                                    droplets.text = "\(player.fetchPlayerDroplets())"
                                }
                            }
                        }
                    }
                }
            }
        }

        self.location = nil
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //check if the contact is between the player and the rock obstacle. if it was, and the player was already in half, we call the handle game over fucntion. if it was and the player was not halfed, we make them halfed by changing the is halfed value to true, and changing the player icon to the halfed worm with the current hat (if any)
        if contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "obstacle" {
            if (isHalfed) {
                handleGameOver()
            } else {
                isHalfed = true
                if let playerNode = contact.bodyA.node as? SKSpriteNode {
                    if currentHat == "none" {
                        playerNode.texture = SKTexture(imageNamed: "halfworm")
                    }
                    if currentHat == "cap" {
                        playerNode.texture = SKTexture(imageNamed: "halfwormcap")
                    }
                    if currentHat == "bow" {
                        playerNode.texture = SKTexture(imageNamed: "halfwormbow")
                    }
                    if currentHat == "sprout" {
                        playerNode.texture = SKTexture(imageNamed: "halfwormsprout")
                    }
                    if currentHat == "catears" {
                        playerNode.texture = SKTexture(imageNamed: "halfwormcatears")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                       // Excecute after 30 seconds
                        self.isHalfed = false
                        playerNode.texture = self.wormTexture
                    }
                }
            }
        }
        
        //if terrain comes in contact with the pixel that watches for terrain collisions, we call spawn terrain again. this makes an endless loop
        if contact.bodyA.node?.name == "terrainWatchPixel" && contact.bodyB.node?.name == "terrain" {
            spawnTerrain()
        }
        if contact.bodyA.node?.name == "terrain" && contact.bodyB.node?.name == "terrainWatchPixel" {
            spawnTerrain()
        }
        
        //if obstacle comes in contact with obstacle watcher node, we spawn another obstacle
        if contact.bodyA.node?.name == "obstacleWatchPixel" && contact.bodyB.node?.name == "obstacle" {
            spawnObstacle()
            spawnPuddle()
        }
    }
    
    //if the game is over, we display the game over banner, home button, and restart button
    func handleGameOver() {
        self.isPaused = true
        gameOverBanner.isHidden = false
        homeButton.isHidden = false
        restartButton.isHidden = false
    }
    
}
