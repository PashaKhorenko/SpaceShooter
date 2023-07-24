//
//  RulesScene.swift
//  Game_Version_2
//
//  Created by Паша Хоренко on 24.07.2023.
//

import SpriteKit

class RulesScene: SKScene {
    
    private var storageManager: RecordStorageManagerProtocol?
    
    // MARK: - UI ELements
    private var startField: SKEmitterNode!
    
    private var titleLabel: SKLabelNode!
    private var goToHomeButton: SKSpriteNode!
    private var recordLabel: SKLabelNode!
    private var rulesLabel: SKLabelNode!
    
    private var recordScore: Int?
    
    // MARK: - Did Move
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        configureBackgroundAnimation()
        configureTitleLabel()
        configureRulesLabel()
        
        configureHomeButton()
    }
    
    // MARK: - UI Configurations
    private func configureBackgroundAnimation() {
        startField = SKEmitterNode(fileNamed: MediaNames.shared.backgroundAnimation)
        startField.position = CGPoint(x: 0.0, y: 1472.0)
        startField.advanceSimulationTime(10.0)
        startField.zPosition = -1
        
        self.addChild(startField)
    }
    
    private func configureTitleLabel() {
        titleLabel = SKLabelNode(fontNamed: "Chalkduster")
        titleLabel.text = "Rules"
        titleLabel.fontSize = 45
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 180)
        
        self.addChild(titleLabel)
    }
    
    private func configureRulesLabel() {
        rulesLabel = SKLabelNode(fontNamed: "Chalkduster")
        rulesLabel.text = "Control the rocket\nby tilting your device."
        rulesLabel.fontSize = 20
        rulesLabel.fontColor = .white
        rulesLabel.numberOfLines = 0
        titleLabel.position = CGPoint(x: frame.midX, y: titleLabel.frame.minY - 30)
        
        self.addChild(rulesLabel)
    }
    
    private func configureHomeButton() {
        goToHomeButton = SKSpriteNode(imageNamed: MediaNames.shared.homeImage)
        goToHomeButton.position = CGPoint(x: frame.minX + 40, y: frame.minY + 40)
        goToHomeButton.setScale(0.12)
        
        self.addChild(goToHomeButton)
    }
    
    // MARK: - Button Actions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if goToHomeButton.contains(location) {
                goToHomeButtonAction()
            }
        }
    }
    
    private func goToHomeButtonAction() {
        guard let view else { return }
        
        if let scene = MainMenuScene(fileNamed: SceneNames.shared.mainMenuScene) {
            let reveal = SKTransition.fade(withDuration: 0.3)
            
            view.presentScene(scene, transition: reveal)
        }
    }
}
