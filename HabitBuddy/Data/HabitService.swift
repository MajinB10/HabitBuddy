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
}

// Data Conversion
extension HabitService {
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
}

// Data Queries
extension HabitService {
    // Add Habit
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
    }
    
    // Delete Habit
    func deleteHabit(_ habit: Habit) {
        habits.removeAll(where: {$0.id == habit.id})
    }
    
    // Update Specific Habit
    func updateHabit (forHabit habit: Habit) {
        guard let index = habits.firstIndex(where: {$0.id == habit.id} ) else { return }
        
        habits[index] = habit
        
        saveHabits()
        
    }
}
