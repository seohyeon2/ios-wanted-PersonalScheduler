//
//  Schedule.swift
//  PersonalSchedule
//
//  Created by seohyeon park on 2023/01/13.
//

import Foundation

struct Schedule: Hashable {
    var title: String
    var date: Date
    var body: String
    var emoji: String
}

struct Dummy {
    var dummy = [
        Schedule(title: "제목", date: Date(), body: "할일이 들어가는 부분할일이 들어가는 부분할일이 들어가는 부분할일이 들어가는 부분할일이 들어가는 부분할일이 들어가는 부분", emoji: "🥳"),
        Schedule(title: "제목", date: Date(), body: "할일이 들어가는 부분", emoji: "📚"),
        Schedule(title: "제목", date: Date(), body: "할일이 들어가는 부분", emoji: "⭐️"),
        Schedule(title: "제목", date: Date(), body: "할일이 들어가는 부분", emoji: "💡"),
        Schedule(title: "제목", date: Date(), body: "할일이 들어가는 부분", emoji: "🎬"),
        Schedule(title: "제목", date: Date(), body: "할일이 들어가는 부분", emoji: "🐶"),
        Schedule(title: "제목", date: Date(), body: "할일이 들어가는 부분", emoji: "🐸"),
        Schedule(title: "제목", date: Date(), body: "할일이 들어가는 부분", emoji: "🐣"),
        Schedule(title: "제목", date: Date(), body: "할일이 들어가는 부분", emoji: "🙊"),
        Schedule(title: "제목", date: Date(), body: "할일이 들어가는 부분", emoji: "😈"),
        Schedule(title: "제목", date: Date(), body: "할일이 들어가는 부분", emoji: "👻"),
        Schedule(title: "제목", date: Date(), body: "할일이 들어가는 부분", emoji: "👾"),
        Schedule(title: "제목", date: Date(), body: "할일이 들어가는 부분", emoji: "💄"),
        Schedule(title: "제목", date: Date(), body: "할일이 들어가는 부분", emoji: "🍎"),
        Schedule(title: "제목", date: Date(), body: "할일이 들어가는 부분", emoji: "🥑")
    ]
}
