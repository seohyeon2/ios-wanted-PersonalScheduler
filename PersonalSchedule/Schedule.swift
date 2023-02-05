//
//  Schedule.swift
//  PersonalSchedule
//
//  Created by seohyeon park on 2023/01/13.
//

import Foundation

struct Schedule: Hashable {
    var id = UUID().description
    var title: String
    var date: Date
    var body: String
    var emoji: String
}
