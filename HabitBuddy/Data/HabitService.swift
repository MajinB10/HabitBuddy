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
    // MARK: - Properties
    
    @AppStorage("GLOBAL_STREAK_KEY") var globalStreak: Int = 0
    @AppStorage("HABITS_KEY") var savedHabits: Data = Data()
    @AppStorage("LAST_GLOBAL_STREAK_DATE") var lastGlobalStreakDate: Date?
    @AppStorage("HABIT_PROGRESS_KEY") private var savedProgress: Data = Data()
    
    private(set) var habitProgress: [HabitProgress] = [] // Progress tracking for charts
    private var habits: [Habit] = []
    
    let habitServiceChanged = PassthroughSubject<Void, Never>()
    
    static let shared = HabitService()
    
    // MARK: - Initializer
    
    init() {
        habits = retrieveHabits()
        habitProgress = retrieveProgress()
    }
}

// MARK: - Habit Progress Functions
extension HabitService {
    // Save progress to storage
    func saveProgress() {
        guard let encoded = try? JSONEncoder().encode(habitProgress) else { return }
        savedProgress = encoded
    }

    // Retrieve progress from storage
    private func retrieveProgress() -> [HabitProgress] {
        guard let decoded = try? JSONDecoder().decode([HabitProgress].self, from: savedProgress) else { return [] }
        return decoded
    }

    // Add or update progress for a specific day
    func updateProgress(for date: Date, completedHabits: Int, totalHabits: Int) {
        let calendar = Calendar.current
        if let index = habitProgress.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            habitProgress[index].completedHabits = completedHabits
            habitProgress[index].totalHabits = totalHabits
        } else {
            let newProgress = HabitProgress(
                id: UUID(),
                date: date,
                completedHabits: completedHabits,
                totalHabits: totalHabits
            )
            habitProgress.append(newProgress)
        }
        saveProgress()
    }

    // Updates progress for the current day
    private func updateDailyProgress() {
        let completedHabits = habits.filter {
            if let lastDate = $0.lastDateDone {
                return isSameDay(date1: lastDate, date2: Date())
            }
            return false
        }.count

        updateProgress(for: Date(), completedHabits: completedHabits, totalHabits: habits.count)
    }
}

// MARK: - Data Conversion
extension HabitService {
    func saveHabits() {
        guard let habitJSON = try? JSONEncoder().encode(habits) else { return }
        self.savedHabits = habitJSON
        habitServiceChanged.send()
        updateDailyProgress() // Update progress whenever habits are saved
    }
    
    func retrieveHabits() -> [Habit] {
        guard let decodeHabit = try? JSONDecoder().decode([Habit].self, from: savedHabits) else { return [] }
        return decodeHabit
    }
}

// MARK: - Data Queries
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

// MARK: - Helper Functions for Metrics
extension HabitService {
    // Aggregate completion breakdown for Pie Chart
    func getCompletionBreakdown() -> (completed: Int, incomplete: Int) {
        let completed = habitProgress.reduce(0) { $0 + $1.completedHabits }
        let total = habitProgress.reduce(0) { $0 + $1.totalHabits }
        return (completed, total - completed)
    }

    // Identify best and worst days
    func getBestAndWorstDays() -> (bestDay: String, worstDay: String) {
        guard let bestDay = habitProgress.max(by: { ($0.completedHabits * 100) / max($0.totalHabits, 1) < ($1.completedHabits * 100) / max($1.totalHabits, 1) }),
              let worstDay = habitProgress.min(by: { ($0.completedHabits * 100) / max($0.totalHabits, 1) < ($1.completedHabits * 100) / max($1.totalHabits, 1) }) else {
            return ("N/A", "N/A")
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return (formatter.string(from: bestDay.date), formatter.string(from: worstDay.date))
    }

    // Individual habit progress for the week
    func getHabitProgressForWeek() -> [String: Int] {
        var habitProgressDict: [String: Int] = [:]
        for habit in habits {
            let weeklyCompleted = habitProgress.filter { progress in
                isSameDay(date1: progress.date, date2: habit.lastDateDone ?? Date())
            }.count
            habitProgressDict[habit.title] = (weeklyCompleted * 100) / max(1, habitProgress.count)
        }
        return habitProgressDict
    }
}
