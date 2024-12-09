//
//  HabitButtonViewModel.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 4/12/24.
//

import Foundation

class HabitButtonViewModel: ObservableObject {
    @Published var habit: Habit
    
    init(habit: Habit) {
        self.habit = habit
    }
    
    func buttonHabitClicked() {
        habit.isDone.toggle()
        
        if (habit.isDone) {
            habit.streak += 1
        } else {
            habit.streak -= 1
        }
    }
}
