//
//  HabitButtonViewModel.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 4/12/24.
//

import Foundation

class HabitButtonViewModel: ObservableObject {
    @Published var habit: Habit
    @Published var isDeleted: Bool = false
    
    init(habit: Habit) {
        self.habit = habit
        validateStreak()
    }
}

// Delete Function
extension HabitButtonViewModel {
    func deleteHabit() {
        print("Deleting Habit: \(habit.title)")
        HabitService.shared.deleteHabit(habit)
        isDeleted = true
    }
}

// Streak and Progress Tracking Functions
extension HabitButtonViewModel {
    func buttonHabitClicked() {
        if !isLastDateSameAsToday() {
            increaseStreak()
            updateGlobalStreak()
            updateDailyProgress()
        }
    }

    func updateGlobalStreak() {
        let allHabitsDone = HabitService.shared.retrieveHabits().allSatisfy {
            isLastDateSameAsToday(date: $0.lastDateDone, isButtonHabit: false)
        }
        if allHabitsDone {
            HabitService.shared.increaseGlobalStreak()
        }
    }

    func increaseStreak() {
        habit.lastDateDone = Date()
        habit.streak += 1
        HabitService.shared.updateHabit(forHabit: habit)
    }

    func validateStreak() {
        guard let lastDateDone = habit.lastDateDone else { return }
        let calendar = Calendar(identifier: .iso8601)
        
        if calendar.numberOfDaysBetween(lastDateDone, and: Date()) > 1 {
            habit.streak = 0
            HabitService.shared.updateHabit(forHabit: habit)
        }
    }

    func isLastDateSameAsToday(date: Date? = nil, isButtonHabit: Bool = true) -> Bool {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        let today = formatter.string(from: Date())
        let dateToCompare = isButtonHabit && habit.lastDateDone != nil
            ? formatter.string(from: habit.lastDateDone!)
            : date != nil ? formatter.string(from: date!) : ""
        
        return today == dateToCompare
    }

    private func updateDailyProgress() {
        let completedHabits = HabitService.shared.retrieveHabits().filter {
            isLastDateSameAsToday(date: $0.lastDateDone)
        }.count
        let totalHabits = HabitService.shared.retrieveHabits().count
        HabitService.shared.updateProgress(for: Date(), completedHabits: completedHabits, totalHabits: totalHabits)
    }
}
