//
//  NetworkManager.swift
//  Game_Version_2
//
//  Created by Паша Хоренко on 24.07.2023.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func fetchData(completioHandler: @escaping (GitModel) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    func fetchData(completioHandler: @escaping (GitModel) -> Void) {
        let urlString = "https://raw.githubusercontent.com/PashaKhorenko/DataForTestTask/main/Contents.json"
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: GitModel.self) { responce in
                switch responce.result {
                case .success(let responceModel):
                        completioHandler(responceModel)
                case .failure(let error):
                    print(error.localizedDescription)
                    completioHandler(GitModel(access: false, link: nil))
                }
            }
    }
    
}
