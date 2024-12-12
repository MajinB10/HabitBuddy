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
    @AppStorage("LAST_GLOBAL_STREAK_DATE") var lastGlobalStreakDate: Date?
    private var habits: [Habit] = []
    
    let habitServiceChanged = PassthroughSubject<Void, Never>()
    
    static let shared = HabitService()
    
    init () {
        habits = retrieveHabits()
    }
}

// Data Conversion
extension HabitService {
    func saveHabits() {
        guard let habitJSON = try? JSONEncoder().encode(habits) else { return }
        self.savedHabits = habitJSON
        habitServiceChanged.send()
    }
    
    func retrieveHabits() -> [Habit] {
        guard let decodeHabit = try? JSONDecoder().decode([Habit].self, from: savedHabits) else { return [] }
        return decodeHabit
    }
}

// Data Queries
extension HabitService {
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
        resetGlobalStreak()
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll(where: { $0.id == habit.id })
        saveHabits()
        updateGlobalStreak()
    }
    
    func updateHabit(forHabit habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index] = habit
        saveHabits()
        updateGlobalStreak()
    }
    
    func increaseGlobalStreak() {
        globalStreak += 1
        habitServiceChanged.send()
    }
    
    func resetGlobalStreak() {
        globalStreak = 0
        habitServiceChanged.send()
    }
    
    func updateGlobalStreak() {
        // Check if all habits are done for today
        let allHabitsDoneToday = habits.allSatisfy { habit in
            guard let lastDateDone = habit.lastDateDone else { return false }
            return isSameDay(date1: lastDateDone, date2: Date())
        }

        // Increment global streak if all habits are done and not already incremented today
        if allHabitsDoneToday, lastGlobalStreakDate == nil || !isSameDay(date1: lastGlobalStreakDate!, date2: Date()) {
            increaseGlobalStreak()
            lastGlobalStreakDate = Date() // Update the last streak increment date
        } else if habits.isEmpty {
            resetGlobalStreak()
        }
    }

    private func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}
