//
//  Date.swift
//  PersonalSchedule
//
//  Created by seohyeon park on 2023/02/06.
//

import Foundation

extension Date {
    func makePrettyDateForm() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        
        return dateFormatter.string(from: self)
    }
}
