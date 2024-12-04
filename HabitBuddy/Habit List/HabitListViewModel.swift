//
//  HabitListViewModel.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 4/12/24.
//

import Foundation


class HabitListViewModel: ObservableObject {
    @Published var habits = [Habit]()
    
    init() {
        habits = DeveloperPreview.habits
    }
}

