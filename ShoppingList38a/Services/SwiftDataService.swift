//
//  SwiftDataService.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 21.09.2026.
//

import SwiftData

@MainActor
final class SwiftDataService {
    let modelContainer: ModelContainer
    
    private var modelContext: ModelContext {
        modelContainer.mainContext
    }
    
    init() {
        do {
            modelContainer = try ModelContainer(
                for: ShoppingList.self, ShoppingItem.self
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}
