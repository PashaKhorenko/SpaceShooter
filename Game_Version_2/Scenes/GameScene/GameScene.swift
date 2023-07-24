//
//  GameScene.swift
//  Game_Version_2
//
//  Created by Паша Хоренко on 23.07.2023.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var storageManager: RecordStorageManagerProtocol?
    
    // MARK: - UI Elements
    private var startField: SKEmitterNode!
    private var player: SKSpriteNode!
    
    private var recordLabel: SKLabelNode!
    private var scoreLabel: SKLabelNode!
    
    // MARK: - Properties
    private var score: Int = 0 {
        didSet {
            self.scoreLabel.text = "Score: \(self.score)"
        }
    }
    
    private var difficultyFactor = 1.0
    
    private var obstacleTimer: Timer?
    private var bonusTimer: Timer?
    private var difficultyTimer: Timer?
    
    private let bulletCategory: UInt32 = 0x1 << 0
    private let obstacleCategory: UInt32 = 0x1 << 1
    private let playerCategory: UInt32 = 0x1 << 2
    private let bonusCategory: UInt32 = 0x1 << 3
    
    private let motionManager = CMMotionManager()
    private var xAccelerate: CGFloat = 0.0
    private var yAcceleration: CGFloat = 0.0
    
    // MARK: - Init
    init(size: CGSize, storageManager: RecordStorageManagerProtocol) {
        super.init(size: size)
        
        self.storageManager = storageManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Did Move
    override func didMove(to view: SKView) {
        super.didMove(to: view)
                
        configureBackgroundAnimation()
        configurePlayer()
        configureRecordLabel()
        configutreScoreLabel()
        configureGameTimers()
        configureMotionManager()
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self
        
        bonusTimer = Timer.scheduledTimer(timeInterval: 10.0,
                                          target: self,
                                          selector: #selector(createNewBonus(_:)),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    // MARK: - Touches Ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        createFireBullet()
    }
    
    // MARK: - Did Simulate Physics
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        player.position.x += xAccelerate * 45
        
        if player.position.x < frame.minX {
            player.position = CGPoint(x: frame.minX, y: player.position.y)
        } else if player.position.x > frame.maxX {
            player.position = CGPoint(x: frame.maxX, y: player.position.y)
        }
        
//        player.position.y += yAcceleration * 50
//
//        if player.position.y < frame.minY {
//            player.position = CGPoint(x: player.position.x, y: frame.minY)
//        } else if player.position.y > frame.maxY {
//            player.position = CGPoint(x: player.position.x, y: frame.maxY)
//        }
    }
    
    // MARK: - UI Configurations
    
    private func configureMotionManager() {
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            guard let data else { return }
            
            let acceleration = data.acceleration
            self.xAccelerate = CGFloat(acceleration.x) * 0.75 + self.xAccelerate * 0.25
            self.yAcceleration = CGFloat(acceleration.y) * 0.75 + self.yAcceleration * 0.25
        }
    }
    
    private func configureBackgroundAnimation() {
        startField = SKEmitterNode(fileNamed: MediaNames.shared.backgroundAnimation)
        startField.position = CGPoint(x: 0.0, y: 1472.0)
        startField.advanceSimulationTime(10.0)
        startField.zPosition = -1
        
        self.addChild(startField)
    }
    
    private func configurePlayer() {
        player = SKSpriteNode(imageNamed: MediaNames.shared.shuttleImage)
        player.position = CGPoint(x: frame.midX, y: frame.minY + 140)
        player.setScale(0.13)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width / 2,
                                                               height: player.size.height / 2))
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = obstacleCategory | bonusCategory
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(player)
    }
    
    private func createFireBullet() {
        let fireBulletAction = SKAction.playSoundFileNamed(MediaNames.shared.torpedoSound, waitForCompletion: false)
        self.run(fireBulletAction)
        
        let bullet = SKSpriteNode(imageNamed: MediaNames.shared.torpedoImage)
        bullet.position = player.position
        bullet.position.y += 8
        bullet.setScale(0.4)
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.height / 2)
        bullet.physicsBody?.isDynamic = true
        
        bullet.physicsBody?.categoryBitMask = bulletCategory
        bullet.physicsBody?.contactTestBitMask = obstacleCategory
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(bullet)
        HapticFeedback.shared.perform()
        
        let animationDuration: TimeInterval = 0.4
        
        var actions: [SKAction] = []
        actions.append(SKAction.move(to: CGPoint(x: player.position.x, y: frame.maxY),
                                     duration: animationDuration))
        actions.append(SKAction.removeFromParent())
        
        bullet.run(SKAction.sequence(actions))
    }
    
    private func configureRecordLabel() {
        let recordScore = storageManager?.getRecordScore()
        
        recordLabel = SKLabelNode(fontNamed: "Chalkduster")
        recordLabel.text = "Best: \(recordScore ?? 0)"
        recordLabel.fontSize = 25.0
        recordLabel.fontColor = .white
        recordLabel.position = CGPoint(x: frame.minX + 75, y: frame.maxY - 65)
        recordLabel.zPosition = 2
        
        self.addChild(recordLabel)
    }
    
    private func configutreScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 25.0
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: frame.maxX - 75, y: frame.maxY - 65)
        scoreLabel.zPosition = 2
        
        self.addChild(scoreLabel)
    }
    
    // MARK: - Timers configuration
    private func configureGameTimers() {
        obstacleTimer?.invalidate()
        obstacleTimer = nil
        
        obstacleTimer = Timer.scheduledTimer(timeInterval: 0.6 * (1.0 / difficultyFactor),
                                             target: self,
                                             selector: #selector(createNewObstacle(_:)),
                                             userInfo: nil,
                                             repeats: true)
        
        difficultyTimer?.invalidate()
        difficultyTimer = nil
        
        difficultyTimer = Timer.scheduledTimer(timeInterval: 10.0,
                                               target: self,
                                               selector: #selector(increaseDifficulty(_:)),
                                               userInfo: nil,
                                               repeats: true)
    }
    
    // MARK: - Timer actions
    @objc private func createNewObstacle(_ sender: Timer) {
        let obstacle = SKSpriteNode(imageNamed: MediaNames.shared.obstacleImage)
        let randomXPos = GKRandomDistribution(lowestValue: Int(frame.minX) + 20, highestValue: Int(frame.maxX) - 20)
        let floatRandomXPos = CGFloat(randomXPos.nextInt())
        
        obstacle.position = CGPoint(x: floatRandomXPos, y: frame.maxY + 20.0)
        obstacle.setScale(0.13)
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = true
        
        obstacle.physicsBody?.categoryBitMask = obstacleCategory
        obstacle.physicsBody?.contactTestBitMask = bulletCategory | playerCategory
        obstacle.physicsBody?.collisionBitMask = 0
        
        self.addChild(obstacle)
        
        let animationDuration: TimeInterval = 6.0 * (1.0 / difficultyFactor)
        
        var actions: [SKAction] = []
        actions.append(SKAction.move(to: CGPoint(x: floatRandomXPos, y: frame.minY - 20.0),
                                     duration: animationDuration))
        actions.append(SKAction.removeFromParent())
        
        obstacle.run(SKAction.sequence(actions))
    }
    
    @objc private func createNewBonus(_ sender: Timer) {
        let bonus = SKSpriteNode(imageNamed: MediaNames.shared.bonusImage)
        let randomXPos = GKRandomDistribution(lowestValue: Int(frame.minX) + 20, highestValue: Int(frame.maxX) - 20)
        let floatRandomXPos = CGFloat(randomXPos.nextInt())
        
        bonus.position = CGPoint(x: floatRandomXPos, y: frame.maxY + 20.0)
        bonus.setScale(0.13)
        
        bonus.physicsBody = SKPhysicsBody(circleOfRadius: bonus.size.height / 2)
        bonus.physicsBody?.isDynamic = true
        
        bonus.physicsBody?.categoryBitMask = bonusCategory
        bonus.physicsBody?.contactTestBitMask = playerCategory
        bonus.physicsBody?.collisionBitMask = 0
        
        self.addChild(bonus)
        
        let animationDuration: TimeInterval = 6.0
        
        var actions: [SKAction] = []
        actions.append(SKAction.move(to: CGPoint(x: floatRandomXPos, y: frame.minY),
                                     duration: animationDuration))
        actions.append(SKAction.removeFromParent())
        
        bonus.run(SKAction.sequence(actions))
    }
    
    @objc private func increaseDifficulty(_ sender: Timer) {
        self.difficultyFactor += 0.2
        self.configureGameTimers()
    }
    
    // MARK: - Collision tracking
    func didBegin(_ contact: SKPhysicsContact) {
        var obstacleBody: SKPhysicsBody?
        var bulletBody: SKPhysicsBody?
        var playerBody: SKPhysicsBody?
        var bonusBody: SKPhysicsBody?
        
        // Determine the physics bodies involved in the contact.
        if contact.bodyA.categoryBitMask == obstacleCategory {
            obstacleBody = contact.bodyA
        } else if contact.bodyA.categoryBitMask == bulletCategory {
            bulletBody = contact.bodyA
        } else if contact.bodyA.categoryBitMask == playerCategory {
            playerBody = contact.bodyA
        } else if contact.bodyA.categoryBitMask == bonusCategory {
            bonusBody = contact.bodyA
        }
        
        if contact.bodyB.categoryBitMask == obstacleCategory {
            obstacleBody = contact.bodyB
        } else if contact.bodyB.categoryBitMask == bulletCategory {
            bulletBody = contact.bodyB
        } else if contact.bodyB.categoryBitMask == playerCategory {
            playerBody = contact.bodyB
        } else if contact.bodyB.categoryBitMask == bonusCategory {
            bonusBody = contact.bodyB
        }
        
        // Handle the collisions based on the detected bodies.
        if let obstacleBody = obstacleBody {
            if let bulletBody = bulletBody {
                // The bullet contacted an obstacle.
                collisionElements(mainNode: bulletBody.node as? SKSpriteNode,
                                  secondaryNode: obstacleBody.node as? SKSpriteNode)
            } else if let playerBody = playerBody {
                // The player contacted an obstacle.
                collisionElements(mainNode: playerBody.node as? SKSpriteNode,
                                  secondaryNode: obstacleBody.node as? SKSpriteNode)
            }
        }
        if let bonusBody = bonusBody {
            // The player contacted the bonus.
            collectBonus(bonusNode: bonusBody.node as? SKSpriteNode)
        }
    }

    private func collisionElements(mainNode: SKSpriteNode?, secondaryNode: SKSpriteNode?) {
        guard let mainNode,
              let secondaryNode else { return }
        
        guard let explosion = SKEmitterNode(fileNamed: MediaNames.shared.explosionAnimation) else { return }
        explosion.position = secondaryNode.position
        explosion.setScale(0.4)
        
        self.addChild(explosion)
        
        let explosionSoundAction = SKAction.playSoundFileNamed(MediaNames.shared.explosionSound, waitForCompletion: false)
        self.run(explosionSoundAction)
        
        mainNode.removeFromParent()
        secondaryNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2.0)) {
            explosion.removeFromParent()
        }
        
        if mainNode == self.player {
            gameOver()
        } else {
            self.score += 1
        }
        
        HapticFeedback.shared.perform()
    }
    
    private func collectBonus(bonusNode: SKSpriteNode?) {
        guard let bonusNode else { return }
        
        let bonusSoundAction = SKAction.playSoundFileNamed(MediaNames.shared.bonusSound, waitForCompletion: false)
        self.run(bonusSoundAction)
        
        bonusNode.removeFromParent()
        
        self.score += 10
        HapticFeedback.shared.perform()
    }
    
    // MARK: - Game over action
    private func gameOver() {
        self.obstacleTimer?.invalidate()
        self.bonusTimer?.invalidate()
        self.difficultyTimer?.invalidate()
        
        self.motionManager.stopAccelerometerUpdates()
        
        let gameOverSoundAction = SKAction.playSoundFileNamed(MediaNames.shared.gameOverSound, waitForCompletion: false)
        self.run(gameOverSoundAction) {
            
            DispatchQueue.main.async {
                self.updateRecord()
            }
            
            let reveal = SKTransition.fade(withDuration: 0.3)
            let gameOverScene = GameOverScene(size: self.size)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    private func updateRecord() {
        guard let oldRecord = storageManager?.getRecordScore() else { return }
        
        if oldRecord < self.score {
            storageManager?.updateResordScore(score)
        }
    }

}
