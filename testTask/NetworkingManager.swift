//
//  NetworkingManager.swift
//  testTask
//
//  Created by Danil Shchegol on 8/3/19.
//  Copyright © 2019 Danil Shchegol. All rights reserved.
//

import Alamofire
import SwiftyJSON

final class NetworkingManager {
    
    static let shared = NetworkingManager()
    
    private init() {}
    
    private let baseURL = "https://api.github.com/"
    
    func searchRepositories(query: String, byPopularity: Bool = false, completion: @escaping (Bool) -> Void) {
        
        let url = URL(string: "\(baseURL)search/repositories")!
        
        let parameters: [String: String] = ["q": query, "sort": byPopularity ? "stars" : "score"]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            
            guard response.result.isSuccess, let resultValue = response.result.value else { completion(false); return }
            var repositories = [Repository]()
            var count: Int = 0
            let itemsArray = JSON(resultValue)["items"].arrayValue
            dump(itemsArray)
            for item in itemsArray {
                guard count < 30 else { break }
                let id = item["id"].intValue
                let name = item["name"].stringValue
                let avatarURL = item["owner"]["avatar_url"].stringValue
                let repURL = item["html_url"].stringValue
                let repository = Repository(id: id, repURL: repURL, avatarURL: avatarURL, name: name, sortedByPopularity: byPopularity)
                repositories.append(repository)
                count += 1
            }
            RealmManager.add(objects: repositories)
            completion(true)
        }
    }
}


