//
//  HabitListViewModel.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 4/12/24.
//

import Foundation


class HabitListViewModel: ObservableObject {
    @Published var habits = [Habit]()
    @Published var dateString: String = Date().formatted()
    
    init() {
        habits = DeveloperPreview.habits
    }
    
    func updateDateString() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long

        return formatter.string(from: currentDate)
    }
    
    func onAddHabitDismissed() {
        habits = DeveloperPreview.habits

    }
    
}

