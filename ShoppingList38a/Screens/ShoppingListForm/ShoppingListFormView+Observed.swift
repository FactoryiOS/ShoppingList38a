//
//  ShoppingListFormView+Observed.swift
//  ShoppingList38a
//
//  Created by Kislov Vadim on 19.09.2026.
//

import Foundation
import SwiftData

extension ShoppingListFormView {
    @MainActor
    @Observable
    final class Observed {
        var name: String = ""
        var selectedIcon: PurchaseIcon?
        var selectedColor: PurchaseColor?
        
        private var currentShoppingList: ShoppingList?
        
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
        
        func fetchShoppingList(by id: ShoppingList.ID?) {
            guard let id, let shoppingList = ShoppingList.mocks.first(where: { $0.id == id }) else {
                return
            }
            
            name = shoppingList.name
            selectedIcon = shoppingList.icon
            selectedColor = shoppingList.color
            
            currentShoppingList = shoppingList
        }
        
        func saveShoppingList(with id: ShoppingList.ID?, completion: Completion) {
            // TODO: добавляем сохранение модели (добавляем или обновляем)
            completion()
        }
    }
}
