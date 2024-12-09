//
//  HabitListViewModel.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 4/12/24.
//

import Foundation


class HabitListViewModel: ObservableObject {
    @Published var habits = [Habit]()
    @Published var dateString: String = ""
    
    init() {
        refreshHabits()
    }
    
    func updateDateString() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long

        return formatter.string(from: currentDate)
    }
    
    func onAddHabitDismissed() {
        refreshHabits()

    }
    
    func refreshHabits() {
        habits = DeveloperPreview.habits

    }
    
}

