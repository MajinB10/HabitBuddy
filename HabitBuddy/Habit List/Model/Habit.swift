//
//  Habit.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 4/12/24.
//

import Foundation

struct Habit: Identifiable {
    let id: String
    var emoji: String
    var title: String
    var description: String
    var streak: Int
    var isDone: Bool = false
}
