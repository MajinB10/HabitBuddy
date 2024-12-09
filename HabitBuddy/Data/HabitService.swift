//
//  HabitService.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 9/12/24.
//

import Foundation
import SwiftUI

class HabitService {
    @AppStorage("HABITS_KEY") var savedHabits: Data = Data()
    private var habits: [Habit] = []
    
    static let shared = HabitService()
    
    init () {
        habits = retrieveHabits()
    }
    
    // Data Conversion
    // Save
    func saveHabits() {
        // Convert to JSON
        guard let habitJSON = try? JSONEncoder().encode(habits) else { return }
        
        self.savedHabits = habitJSON
    }
    
    // Retrieve
    func retrieveHabits() -> [Habit]{
        guard let decodeHabit = try? JSONDecoder().decode([Habit].self, from: savedHabits) else { return [] }
        
        return decodeHabit
    }
    
    // Data Queries
    // Add
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
    }
    
    // Delete
    func deleteHabit(_ habit: Habit) {
        habits.removeAll(where: {$0.id == habit.id})
    }
}
