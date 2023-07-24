//
//  RecordScene.swift
//  Game_Version_2
//
//  Created by Паша Хоренко on 24.07.2023.
//

import SpriteKit

class RecordScene: SKScene {
    
    private var storageManager: RecordStorageManagerProtocol?
    
    // MARK: - UI ELements
    private var startField: SKEmitterNode!
    
    private var titleLabel: SKLabelNode!
    private var goToHomeButton: SKSpriteNode!
    
    private var recordLabel: SKLabelNode!
    
    private var recordScore: Int?
    
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
        recordScore = storageManager?.getRecordScore()
        
        configureBackgroundAnimation()
        configureTitleLabel()
        
        configureRecordLabel()
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
        titleLabel.text = "Resord"
        titleLabel.fontSize = 45
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 180)
        
        self.addChild(titleLabel)
    }
    
    private func configureHomeButton() {
        goToHomeButton = SKSpriteNode(imageNamed: MediaNames.shared.homeImage)
        goToHomeButton.position = CGPoint(x: frame.minX + 40, y: frame.minY + 40)
        goToHomeButton.setScale(0.12)
        
        self.addChild(goToHomeButton)
    }
    
    private func configureRecordLabel() {
        recordLabel = SKLabelNode(fontNamed: "Chalkduster")
        recordLabel.text = "Resord: \(self.recordScore ?? 0)"
        recordLabel.fontSize = 30
        recordLabel.fontColor = .white
        recordLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        
        self.addChild(recordLabel)
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
