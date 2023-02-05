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
    private(set) var schedules = [[String : Any]]()

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
                    self.schedules = [[String : Any]]()
                    for document in data.documents {
                        self.schedules.append(document.data())
                    }
                    handler(self.schedules)
                }
            }
        }
    }
    
    func save(_ model: Schedule) {
        guard let collectionName = UserDefaults.standard.object(forKey: "userID") as? String else {
            return
        }

        db.collection(collectionName).document(model.date.description).setData([
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
    
    func delete(date: String) {
        guard let collectionName = UserDefaults.standard.object(forKey: "userID") as? String else {
            return
        }

        db.collection(collectionName).document(date).delete() { error in
            if let error = error {
                print(error)
            }
        }
    }
}
