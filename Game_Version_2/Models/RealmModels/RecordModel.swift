//
//  RecordModel.swift
//  Game_Version_2
//
//  Created by Паша Хоренко on 24.07.2023.
//

import RealmSwift

class RecordModel: Object {
    @Persisted dynamic var recordScore: Int = 0
}
