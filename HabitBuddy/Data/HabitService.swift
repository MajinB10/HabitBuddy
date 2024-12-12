//
//  HabitService.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 9/12/24.
//

import Foundation
import SwiftUI
import Combine

class HabitService {
    @AppStorage("GLOBAL_STREAK_KEY") var globalStreak: Int = 0
    @AppStorage("HABITS_KEY") var savedHabits: Data = Data()
    private var habits: [Habit] = []
    
    let habitServiceChanged = PassthroughSubject<Void, Never>()
    
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
        
        habitServiceChanged.send()
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
        saveHabits()
        updateGlobalStreak()
    }
    
    // Update Specific Habit
    func updateHabit (forHabit habit: Habit) {
        guard let index = habits.firstIndex(where: {$0.id == habit.id} ) else { return }
        
        habits[index] = habit
        
        saveHabits()
        
    }
    
    // Increase Global Streak
    func increaseGlobalStreak() {
        globalStreak += 1
        habitServiceChanged.send()
        
    }
    
    // Reset Gloabal Streak
    func resetGlobalStreak() {
        globalStreak = 0
        habitServiceChanged.send()
    }
    
    func updateGlobalStreak() {
        if (habits.count == 0) {
            resetGlobalStreak()
        }
    }
}
