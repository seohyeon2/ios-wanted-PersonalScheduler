//
//  FirebaseManager.swift
//  PersonalSchedule
//
//  Created by seohyeon park on 2023/02/06.
//

import FirebaseFirestore


class FirebaseManager {
    static let shared =  FirebaseManager()
    private let db = Firestore.firestore()

    private init() {}
    
    func fetch(handler: (@escaping ([[String : Any]]) -> Void)) {
        guard let collectionName = UserDefaults.standard.object(forKey: "userID") as? String else {
            return
        }
        db.collection(collectionName).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print(error)
            } else {
                if let data = querySnapshot {
                    var schedules = [[String : Any]]()
                    for document in data.documents {
                        schedules.append(document.data())
                    }
                    handler(schedules)
                }
            }
        }
    }
    
    func save(_ model: Schedule) {
        guard let collectionName = UserDefaults.standard.object(forKey: "userID") as? String else {
            return
        }

        db.collection(collectionName).document(model.id).setData([
            "id": model.id,
            "date": model.date.description,
            "title": model.title,
            "body": model.body,
            "emoji": model.emoji
        ]) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func delete(id: String) {
        guard let collectionName = UserDefaults.standard.object(forKey: "userID") as? String else {
            return
        }

        db.collection(collectionName).document(id).delete() { error in
            if let error = error {
                print(error)
            }
        }
    }
}
