//
//  Developer Preview.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 4/12/24.
//

import Foundation


class DeveloperPreview {
    // Mock Habit Object
    static let habits: [Habit] = [
        .init(
            id: NSUUID().uuidString,
            emoji: "🧘🏼‍♀️",
            title: "Meditation",
            description: "Take 10 mins to Breathe",
            streak: 0
        ),
        .init(
            id: NSUUID().uuidString,
            emoji: "🏋🏼",
            title: "Workout",
            description: "Have a 30 mins workout",
            streak: 0
        ),
        .init(
            id: NSUUID().uuidString,
            emoji: "👋",
            title: "Social",
            description: "Call a Friend",
            streak: 0
        )
        
    ]
}
