//
//  GameViewController.swift
//  Game_Version_2
//
//  Created by Паша Хоренко on 23.07.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openMainMenu()
        NotificationCenter.default.addObserver(self, selector: #selector(test(_:)), name: NSNotification.Name("OpenWebVC"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("OpenWebVC"), object: nil)
    }
    
    @objc private func test(_ sender: Notification) {
        guard let link = sender.userInfo?["link"] as? String else { return }
                
        let webViewVC = WebVeiwViewController(nibName: "WebVeiwViewController", bundle: nil)
        webViewVC.link = link
        webViewVC.modalPresentationStyle = .fullScreen
        
        present(webViewVC, animated: true)
    }
    
    private func openMainMenu() {
        if let view = self.view as! SKView? {
            if let scene = MainMenuScene(fileNamed: SceneNames.shared.mainMenuScene) {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.size = view.bounds.size
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
