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
            updateGlobalStreak()
        }
    }
    
    func updateGlobalStreak() {
        var allHabitsAreDone = true
        for h in HabitService.shared.retrieveHabits() {
            if !isLastDateSameAsToday(date: h.lastDateDone, isButtonHabit: false) {
                allHabitsAreDone = false
            }
        }
        if (allHabitsAreDone) {
            HabitService.shared.increaseGlobalStreak()
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
            HabitService.shared.resetGlobalStreak()
        }
            
    }
    
    func isLastDateSameAsToday(date: Date? = nil, isButtonHabit: Bool = true) -> Bool {
            
        // Formatter
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
            
        // Today's Date
        let today = formatter.string(from: Date())
        
        // Date to Compare
        var dateToCompare = ""
        
        if(isButtonHabit && habit.lastDateDone != nil) {
            dateToCompare = formatter.string(from: habit.lastDateDone!)
        } else if  (!isButtonHabit && date != nil) {
            dateToCompare = formatter.string(from: date!)
        }
        
        return today == dateToCompare

    }
}
