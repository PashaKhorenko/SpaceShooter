//
//  LoadingScene.swift
//  Game_Version_2
//
//  Created by Паша Хоренко on 24.07.2023.
//

import SpriteKit

class LoadingScene: SKScene {
    
    private var networkManager: NetworkManagerProtocol?
    
    // MARK: - UI ELements
    private var startField: SKEmitterNode!
    private var messageLabel: SKLabelNode!
    
    // MARK: - Init
    init(size: CGSize, networkManager: NetworkManagerProtocol) {
        super.init(size: size)
        
        self.networkManager = networkManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Did Move
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        configureBackgroundAnimation()
        configureMessageLabel()
        
        networkManager?.fetchData { [weak self] responceData in
            print(responceData)
            guard let self else { return }
            
            guard let access = responceData.access,
                  let link = responceData.link else { return }
            
            if access {
                self.openWebViewScene(byLink: link)
            } else {
                self.openGameScene()
            }
            
        }
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
        messageLabel.text = "Loading..."
        messageLabel.fontSize = 40
        messageLabel.fontColor = .white
        messageLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        
        self.addChild(messageLabel)
    }
    
    // MARK: - Navigation
    private func openWebViewScene(byLink link: String) {
        NotificationCenter.default.post(name: NSNotification.Name("OpenWebVC"), object: nil, userInfo: ["link": link])
    }
    
    private func openGameScene() {
        
        guard let view else { return }
        
        let scene = GameScene(size: view.bounds.size, storageManager: RecordStorageManager())
        let reveal = SKTransition.fade(withDuration: 0.3)
        
        view.presentScene(scene, transition: reveal)
    }
    
}
