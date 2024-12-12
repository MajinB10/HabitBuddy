//
//  HabitProgress.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 12/12/24.
//

import Foundation

struct HabitProgress: Codable, Identifiable {
    let id: UUID
    let date: Date
    var completedHabits: Int
    var totalHabits: Int
    
    var progressPercentage: Int {
        totalHabits > 0 ? Int((Double(completedHabits) / Double(totalHabits)) * 100) : 0
    }
}
