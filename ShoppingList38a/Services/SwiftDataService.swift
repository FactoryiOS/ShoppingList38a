//
//  SwiftDataService.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 21.09.2026.
//

import Foundation
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

    // MARK: - ShoppingList

    func createShoppingList(
        name: String,
        icon: PurchaseIcon,
        color: PurchaseColor
    ) throws {
        let model = ShoppingList(
            name: trimmed(name),
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
        shoppingList.name = trimmed(name)
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

        let sortedItems = shoppingList.items.sorted {
            $0.createdAt < $1.createdAt
        }

        let model = ShoppingList(
            name: duplicateName,
            icon: shoppingList.icon,
            color: shoppingList.color
        )

        modelContext.insert(model)

        let baseDate = Date.now

        for (index, item) in sortedItems.enumerated() {
            let duplicatedItem = ShoppingItem(
                name: item.name,
                count: item.count,
                unit: item.unit,
                // Добавляем 1 мс на каждый следующий товар,
                // чтобы сохранить исходный порядок элементов,
                // но при этом задать новым копиям собственные createdAt.
                createdAt: baseDate.addingTimeInterval(
                    TimeInterval(index) * 0.001
                )
            )
            model.items.append(duplicatedItem)
            modelContext.insert(duplicatedItem)
        }

        try modelContext.save()
    }

    func fetchShoppingList(
        by id: ShoppingList.ID
    ) -> ShoppingList? {
        let descriptor = FetchDescriptor<ShoppingList>(
            predicate: #Predicate {
                $0.persistentModelID == id
            }
        )

        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            print("❌ [SwiftDataService] fetchShoppingList: \(error)")
            return nil
        }
    }

    /// Проверяет доступность названия без учёта регистра и крайних пробелов.
    /// При редактировании исключает переданный список из проверки.
    ///
    /// Пример:
    ///
    /// `Продукты` и `продукты` — дубликат;
    /// `Продукты` и `ПРОДУКТЫ` — дубликат;
    /// ` Продукты ` и `продукты` — дубликат.
    ///
    /// - Parameters:
    ///   - name: Проверяемое название.
    ///   - shoppingList: Редактируемый список, исключаемый из проверки.
    /// - Returns: `true`, если название доступно.
    /// - Throws: Ошибка получения списков из SwiftData.
    func isShoppingListNameAvailable(
        _ name: String,
        excluding shoppingList: ShoppingList? = nil
    ) throws -> Bool {
        let descriptor = FetchDescriptor<ShoppingList>()
        let lists = try modelContext.fetch(descriptor)

        let normalizedName = name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        return !lists.contains { list in
            if let shoppingList,
               list.id == shoppingList.id {
                return false
            }

            let existingName = list.name
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()

            return existingName == normalizedName
        }
    }

    // MARK: - ShoppingItem

    func addShoppingItem(
        to shoppingList: ShoppingList,
        name: String,
        count: Int,
        unit: ShoppingItemUnit
    ) throws {
        let model = ShoppingItem(
            name: trimmed(name),
            count: count,
            unit: unit
        )

        shoppingList.items.append(model)
        modelContext.insert(model)

        try modelContext.save()
    }

    func updateShoppingItem(
        _ shoppingItem: ShoppingItem,
        name: String,
        count: Int,
        unit: ShoppingItemUnit
    ) throws {
        shoppingItem.name = trimmed(name)
        shoppingItem.count = count
        shoppingItem.unit = unit

        try modelContext.save()
    }

    func deleteShoppingItem(
        _ shoppingItem: ShoppingItem
    ) throws {
        if let shoppingList = shoppingItem.list {
            shoppingList.items.removeAll {
                $0.id == shoppingItem.id
            }
        }

        modelContext.delete(shoppingItem)

        try modelContext.save()
    }

    func toggleShoppingItem(
        _ shoppingItem: ShoppingItem
    ) throws {
        shoppingItem.isPurchased.toggle()

        try modelContext.save()
    }

    func resetPurchasedItems(
        in shoppingList: ShoppingList
    ) throws {
        shoppingList.items.forEach {
            $0.isPurchased = false
        }

        try modelContext.save()
    }

    func deletePurchasedItems(
        in shoppingList: ShoppingList
    ) throws {
        let purchasedItems = shoppingList.items.filter {
            $0.isPurchased
        }

        shoppingList.items.removeAll {
            $0.isPurchased
        }

        purchasedItems.forEach {
            modelContext.delete($0)
        }

        try modelContext.save()
    }

    func fetchShoppingItem(
        by id: ShoppingItem.ID
    ) -> ShoppingItem? {
        let descriptor = FetchDescriptor<ShoppingItem>(
            predicate: #Predicate {
                $0.persistentModelID == id
            }
        )

        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            print("❌ [SwiftDataService] fetchShoppingItem: \(error)")
            return nil
        }
    }

    func fetchAllUniqueItemNames() -> Set<String> {
        let descriptor = FetchDescriptor<ShoppingItem>()

        do {
            let allItems = try modelContext.fetch(descriptor)

            let names = allItems
                .map { $0.name.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }

            let uniqueNames = Dictionary(
                names.map { ($0.lowercased(), $0) },
                uniquingKeysWith: { first, _ in first }
            )

            return Set(uniqueNames.values)
        } catch {
            print("❌ [SwiftDataService] fetchAllUniqueItemNames: \(error)")
            return []
        }
    }

    // MARK: - Helpers

    /// Формирует имя следующего дубликата в формате `<название> копия N`.
    ///
    /// Номер выбирается как следующий после максимального существующего.
    /// Уже продублированный список считается самостоятельной основой:
    /// `Продукты копия 2` → `Продукты копия 2 копия 1`.
    ///
    /// - Parameter shoppingList: Дублируемый список.
    /// - Returns: Имя нового дубликата.
    /// - Throws: Ошибка получения списков из SwiftData.
    private func nextDuplicateName(
        for shoppingList: ShoppingList
    ) throws -> String {
        let descriptor = FetchDescriptor<ShoppingList>()
        let lists = try modelContext.fetch(descriptor)

        let copySuffix = String(localized: .copySuffix)
        let prefix = "\(shoppingList.name) \(copySuffix) "

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

    private func trimmed(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
