//
//  WebVeiwViewController.swift
//  Game_Version_2
//
//  Created by Паша Хоренко on 24.07.2023.
//

import UIKit
import WebKit

class WebVeiwViewController: UIViewController {
    
    var link: String?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        configureWebView()
    }
    
    private func configureWebView() {
        guard let link, let url = URL(string: link) else { return }
        
        let request = URLRequest(url: url)
        self.webView.load(request)
        
    }
    
}
