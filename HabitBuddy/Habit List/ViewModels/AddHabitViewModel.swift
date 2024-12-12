//
//  AddHabitViewModel.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 9/12/24.
//

import Foundation
class AddHabitViewModel: ObservableObject {
    @Published var emoji: String = ""
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var error: String = ""
    
    func addNewHabit() -> Bool {
        if validateNewHabit() {
            error = ""
            HabitService.shared.addHabit(
                Habit(id: UUID().uuidString,
                      emoji: emoji,
                      title: title,
                      description: description,
                      streak: 0)
            )
            eraseTextField()
        } else {
            error = "Please make sure all fields are filled"
            return false
        }
        return true
    }
    
    private func validateNewHabit() -> Bool {
        return emoji.count > 0 && title.count > 1 && description.count > 1
    }
    
    private func eraseTextField() {
        emoji = ""
        title = ""
        description = ""
    }
}
