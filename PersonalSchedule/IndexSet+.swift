//
//  IndexSet+.swift
//  PersonalSchedule
//
//  Created by seohyeon park on 2023/02/06.
//

import Foundation

extension IndexSet {
    func changeInt() -> Int? {
        guard let indexToString = self.first?.description.filter({ $0.isNumber }),
            let number = Int(indexToString) else {
            return nil
        }

        return number
    }
}
