//
//  GameOverScene.swift
//  Game_Version_2
//
//  Created by Паша Хоренко on 23.07.2023.
//

import SpriteKit

class GameOverScene: SKScene {
    
    // MARK: - UI ELements
    private var startField: SKEmitterNode!
    private var messageLabel: SKLabelNode!
    
    private var goToMainButton: SKLabelNode!
    private var restoreButton: SKLabelNode!
    
    // MARK: - Did Move
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        configureBackgroundAnimation()
        configureMessageLabel()
        
        configureGoToMainButton()
        configureRestoreButton()
    }
    
    // MARK: - UI Configurations
    private func configureBackgroundAnimation() {
        startField = SKEmitterNode(fileNamed: MediaNames.shared.backgroundAnimation)
        startField.position = CGPoint(x: 0.0, y: 1472.0)
        startField.advanceSimulationTime(10.0)
        startField.zPosition = -1
        
        self.addChild(startField)
    }
    
    private func configureMessageLabel() {
        messageLabel = SKLabelNode(fontNamed: "Chalkduster")
        messageLabel.text = "Game Over :["
        messageLabel.fontSize = 40
        messageLabel.fontColor = .white
        messageLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        
        self.addChild(messageLabel)
    }
    
    private func configureGoToMainButton() {
        goToMainButton = SKLabelNode(fontNamed: "Chalkduster")
        goToMainButton.text = "Go To Main"
        goToMainButton.fontSize = 35
        goToMainButton.fontColor = .white
        goToMainButton.position = CGPoint(x: frame.midX, y: frame.midY - 160.0)
        
        self.addChild(goToMainButton)
    }
    
    private func configureRestoreButton() {
        restoreButton = SKLabelNode(fontNamed: "Chalkduster")
        restoreButton.text = "Restore"
        restoreButton.fontSize = 35
        restoreButton.fontColor = .white
        restoreButton.position = CGPoint(x: frame.midX, y: frame.midY - 220.0)
        
        self.addChild(restoreButton)
    }
    
    // MARK: - Button Actions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if restoreButton.contains(location) {
                restoreButtonAction()
            } else if goToMainButton.contains(location) {
                goToMainButtonAction()
            }
        }
    }
    
    private func goToMainButtonAction() {
        guard let view else { return }
        
        if let scene = MainMenuScene(fileNamed: SceneNames.shared.mainMenuScene) {
            let reveal = SKTransition.fade(withDuration: 0.3)
            
            view.presentScene(scene, transition: reveal)
        }
    }
    
    private func restoreButtonAction() {
        guard let view else { return }
        
        let scene = GameScene(size: view.bounds.size, storageManager: RecordStorageManager())
        let reveal = SKTransition.fade(withDuration: 0.3)
        
        view.presentScene(scene, transition: reveal)
    }

}
