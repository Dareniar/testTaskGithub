//
//  RealmModels.swift
//  testTask
//
//  Created by Danil Shchegol on 8/3/19.
//  Copyright © 2019 Danil Shchegol. All rights reserved.
//

import RealmSwift

class Repository: Object {
    
    let id = RealmOptional<Int>()
    
    @objc dynamic var repURL: String?
    @objc dynamic var avatarURL: String?
    @objc dynamic var name: String?
    
    let sortedByPopularity = RealmOptional<Bool>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, repURL: String, avatarURL: String, name: String, sortedByPopularity: Bool = false) {
        self.init()
        self.id.value = id
        self.repURL = repURL
        self.avatarURL = avatarURL
        self.name = name
        self.sortedByPopularity.value = sortedByPopularity
    }
}
