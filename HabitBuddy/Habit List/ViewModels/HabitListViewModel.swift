//
//  HabitListViewModel.swift
//  HabitBuddy
//
//  Created by Bhavesh Anand on 4/12/24.
//

import Foundation
import Combine


class HabitListViewModel: ObservableObject {
    @Published var globalStreak = 0
    @Published var habits = [Habit]()
    @Published var dateString: String = ""

    let UIchange = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        refreshHabits()
        refreshGlobalStreak()
        dateString = updateDateString()
        
        HabitService.shared.habitServiceChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refreshHabits()
                self?.refreshGlobalStreak()
            }
            .store(in: &cancellables)
        
        if habits.isEmpty {
            HabitService.shared.resetGlobalStreak()
        }
    }
    
    func updateDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
    
    func onAddHabitDismissed() {
        refreshHabits()
    }
    
    func refreshHabits() {
        habits = HabitService.shared.retrieveHabits()
        updateDailyProgress()
        UIchange.send()
    }
    
    func refreshGlobalStreak() {
        globalStreak = HabitService.shared.globalStreak
        UIchange.send()
    }
    
    private func updateDailyProgress() {
        let completedHabits = habits.filter { habit in
            guard let lastDateDone = habit.lastDateDone else { return false }
            return Calendar.current.isDateInToday(lastDateDone)
        }.count
        
        HabitService.shared.updateProgress(
            for: Date(),
            completedHabits: completedHabits,
            totalHabits: habits.count
        )
    }
}

