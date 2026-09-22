//
//  ShoppingListFormView+Observed.swift
//  ShoppingList38a
//
//  Created by Kislov Vadim on 19.09.2026.
//

import Foundation

extension ShoppingListFormView {
    @MainActor
    @Observable
    final class Observed {
        var name: String = ""
        var selectedIcon: PurchaseIcon?
        var selectedColor: PurchaseColor?
        
        private let service: SwiftDataService
        private let currentShoppingList: ShoppingList?
        
        init(
            service: SwiftDataService,
            shoppingList: ShoppingList? = nil
        ) {
            self.service = service
            self.currentShoppingList = shoppingList

            if let shoppingList {
                name = shoppingList.name
                selectedIcon = shoppingList.icon
                selectedColor = shoppingList.color
            }
        }
        
        private var trimmedName: String {
            name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        var isValid: Bool {
            !trimmedName.isEmpty
            && nameErrorMessage == nil
            && selectedIcon != nil
            && selectedColor != nil
        }
        
        var submitButtonTitle: String {
            currentShoppingList != nil ? "Сохранить" : "Создать"
        }
        
        var titleToolbar: String {
            currentShoppingList != nil ? "Редактировать список" : "Создать список"
        }
        
        var nameErrorMessage: String? {
            if name.isEmpty || name == currentShoppingList?.name {
                return nil
            }
            
            guard ShoppingList.mocks.first(where: { $0.name.lowercased() == name.lowercased() }) != nil else {
                return nil
            }
            
            return "Это название уже используется, пожалуйста, измените его."
        }
        
        func handleSave(completion: Completion) {
            // TODO: добавляем сохранение модели (добавляем или обновляем)
            completion()
        }
    }
}
