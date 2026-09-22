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
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    // MARK: - Работа с ShoppingList
    
    func createShoppingList(
        name: String,
        icon: PurchaseIcon,
        color: PurchaseColor
    ) throws {
        let model = ShoppingList(
            name: name,
            icon: icon,
            color: color
        )
        
        modelContext.insert(model)
        
        try modelContext.save()
    }
    
    func updateShoppingList(
        _ shoppingList: ShoppingList,
        name: String,
        icon: PurchaseIcon,
        color: PurchaseColor
    ) throws {
        shoppingList.name = name
        shoppingList.icon = icon
        shoppingList.color = color
        
        try modelContext.save()
    }
    
    func deleteShoppingList(
        _ shoppingList: ShoppingList
    ) throws {
        modelContext.delete(shoppingList)
        
        try modelContext.save()
    }
    
    func duplicateShoppingList(
        _ shoppingList: ShoppingList
    ) throws {
        let duplicateName = try nextDuplicateName(
            for: shoppingList
        )
        
        let model = ShoppingList(
            name: duplicateName,
            icon: shoppingList.icon,
            color: shoppingList.color,
            items: shoppingList.items.map {
                ShoppingItem(
                    title: $0.title,
                    count: $0.count,
                    unit: $0.unit
                )
            }
        )
        
        modelContext.insert(model)
        
        try modelContext.save()
    }
    
    // MARK: - Работа с ShoppingItem
    
    func addShoppingItem(
        to shoppingList: ShoppingList,
        title: String,
        count: Int,
        unit: ShoppingItemUnit
    ) throws {
        let model = ShoppingItem(
            title: title,
            count: count,
            unit: unit
        )
        
        shoppingList.items.append(model)
        modelContext.insert(model)
        
        try modelContext.save()
    }
    
    func updateShoppingItem(
        _ shoppingItem: ShoppingItem,
        title: String,
        count: Int,
        unit: ShoppingItemUnit
    ) throws {
        shoppingItem.title = title
        shoppingItem.count = count
        shoppingItem.unit = unit
        
        try modelContext.save()
    }
    
    func deleteShoppingItem(
        _ shoppingItem: ShoppingItem
    ) throws {
        modelContext.delete(shoppingItem)
        
        try modelContext.save()
    }
    
    func toggleShoppingItem(
        _ shoppingItem: ShoppingItem
    ) throws {
        shoppingItem.isPurchased.toggle()
        
        try modelContext.save()
    }
    
    // MARK: - Helpers
    
    /// Формирует имя для нового дубликата списка.
    ///
    /// Метод ищет среди существующих списков дубликаты текущего списка
    /// с именами в формате `<название> копия N`, находит максимальный номер
    /// и увеличивает его на 1.
    ///
    /// Например, если существуют:
    /// `Продукты копия 1`, `Продукты копия 2` и `Продукты копия 4`,
    /// следующий дубликат получит имя `Продукты копия 5`.
    ///
    /// Если дублируется уже существующая копия, она считается отдельной основой.
    /// Например, для `Продукты копия 2` следующий дубликат может называться
    /// `Продукты копия 2 копия 1`.
    ///
    /// - Parameter shoppingList: Список, для которого нужно сформировать имя дубликата.
    /// - Returns: Имя нового дубликата с очередным номером.
    /// - Throws: Ошибка получения существующих списков из SwiftData.
    private func nextDuplicateName(
        for shoppingList: ShoppingList
    ) throws -> String {
        let descriptor = FetchDescriptor<ShoppingList>()
        let lists = try modelContext.fetch(descriptor)
        
        let prefix = "\(shoppingList.name) копия "
        
        let lastCopyNumber = lists
            .compactMap { list -> Int? in
                guard list.name.hasPrefix(prefix) else {
                    return nil
                }
                
                let suffix = list.name.dropFirst(prefix.count)
                
                return Int(suffix)
            }
            .max() ?? 0
        
        return "\(prefix)\(lastCopyNumber + 1)"
    }
}
