//
//  RecordStorageManager.swift
//  Game_Version_2
//
//  Created by Паша Хоренко on 24.07.2023.
//

import Foundation
import RealmSwift

protocol RecordStorageManagerProtocol {
    func updateResordScore(_ newRecord: Int)
    func getRecordScore() -> Int
}

class RecordStorageManager: RecordStorageManagerProtocol {
    
    private let realm = try! Realm()
    
    // MARK: - Private
    private func createFirstRecordObject(_ newRecord: Int) {
        let recordObject = RecordModel()
    
        do {
            try realm.write {
                recordObject.recordScore = newRecord
                realm.add(recordObject)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getFirstRecordObject() -> RecordModel? {
        guard let recordObject = realm.objects(RecordModel.self).first else { return nil }
        return recordObject
    }
    
    // MARK: - Public
    func updateResordScore(_ newRecord: Int) {
        guard let recordObject = getFirstRecordObject() else {
            createFirstRecordObject(newRecord)
            return
        }
        
        do {
            try realm.write {
                recordObject.recordScore = newRecord
                realm.add(recordObject)
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func getRecordScore() -> Int {
        guard let recordObject = getFirstRecordObject() else { return 0 }
        return recordObject.recordScore
    }
    
}
