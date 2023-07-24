//
//  MainMenuScene.swift
//  Game_Version_2
//
//  Created by Паша Хоренко on 23.07.2023.
//

import SpriteKit

class MainMenuScene: SKScene {
        
    // MARK: - UI ELements
    private var startField: SKEmitterNode!
    
    private var titleLabel: SKLabelNode!
    
    private var rulesButton: SKLabelNode!
    private var reсordButton: SKLabelNode!
    private var playButton: SKLabelNode!
    
    // MARK: - Did Move
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        configureBackgroundAnimation()
        configureTitleLabel()
        
        configureRulesButton()
        configureRecordButton()
        configurePlayButton()
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
        titleLabel.text = "Space Shooter"
        titleLabel.fontSize = 45
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 180)
        
        self.addChild(titleLabel)
    }
    
    private func configureRulesButton() {
        rulesButton = SKLabelNode(fontNamed: "Chalkduster")
        rulesButton.text = "Rules"
        rulesButton.fontSize = 35
        rulesButton.fontColor = .white
        rulesButton.position = CGPoint(x: frame.midX, y: frame.midY - 60)
        
        self.addChild(rulesButton)
    }
    
    private func configureRecordButton() {
        reсordButton = SKLabelNode(fontNamed: "Chalkduster")
        reсordButton.text = "Reсord"
        reсordButton.fontSize = 35
        reсordButton.fontColor = .white
        reсordButton.position = CGPoint(x: frame.midX, y: rulesButton.position.y - 60)
        
        self.addChild(reсordButton)
    }
    
    private func configurePlayButton() {
        playButton = SKLabelNode(fontNamed: "Chalkduster")
        playButton.text = "New Game"
        playButton.fontSize = 35
        playButton.fontColor = .white
        playButton.position = CGPoint(x: frame.midX, y: reсordButton.position.y - 60)
        
        self.addChild(playButton)
    }
    
    // MARK: - Button Actions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if rulesButton.contains(location) {
                rulesButtonAction()
            } else if reсordButton.contains(location) {
                recordButtonAction()
            } else if playButton.contains(location) {
                playButtonAction()
            }
        }
    }
    
    private func rulesButtonAction() {
        guard let view else { return }
        
        if let scene = RulesScene(fileNamed: SceneNames.shared.rulesScene) {
            let reveal = SKTransition.fade(withDuration: 0.3)
            
            view.presentScene(scene, transition: reveal)
        }
    }
    
    private func recordButtonAction() {
        guard let view else { return }
        
        let scene = RecordScene(size: view.bounds.size, storageManager: RecordStorageManager())
        let reveal = SKTransition.fade(withDuration: 0.3)
        
        view.presentScene(scene, transition: reveal)
    }
    
    private func playButtonAction() {
        guard let view else { return }
        
        let scene = LoadingScene(size: view.bounds.size, networkManager: NetworkManager())
        let reveal = SKTransition.fade(withDuration: 0.3)
        
        view.presentScene(scene, transition: reveal)
    }    
}
