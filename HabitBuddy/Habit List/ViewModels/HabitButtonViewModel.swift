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
        HabitService.shared.deleteHabit(habit)
        isDeleted = true
    }
}

// Streak Function
extension HabitButtonViewModel {
    func buttonHabitClicked() {
        if (!isLastDateSameAsToday()) {
            increaseStreak()
        }
    }
    
    func increaseStreak() {
        habit.lastDateDone = Date()
        habit.streak += 1
        HabitService.shared.updateHabit(forHabit: habit)
    }
    
    func validateStreak() {
        guard let lastDateDone  = habit.lastDateDone else { return }
        let calendar = Calendar(identifier: .iso8601)
        
        if (calendar.numberOfDaysBetween(lastDateDone, and: Date()) > 2) {
            habit.streak = 0
            HabitService.shared.updateHabit(forHabit: habit)
        }
            
    }
    
    func isLastDateSameAsToday() -> Bool {
        if (habit.lastDateDone != nil) {
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .short
            
            let today = formatter.string(from: Date())
            let lastDateDone = formatter.string(from: habit.lastDateDone!)
            
            return today == lastDateDone
        }
        
        return false
    }
}
