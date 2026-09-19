//
//  PurchaseFormView+Observed.swift
//  ShoppingList38a
//
//  Created by Kislov Vadim on 19.09.2026.
//

import Foundation

extension PurchaseFormView {
    @MainActor
    @Observable
    final class Observed {
        var name: String = ""
        var selectedIcon: PurchaseIcon?
        var selectedColor: PurchaseColor?
        
        private var currentPurchase: Purchase?
        
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
            currentPurchase != nil ? "Сохранить" : "Создать"
        }
        
        var titleToolbar: String {
            currentPurchase != nil ? "Редактировать список" : "Создать список"
        }
        
        var nameErrorMessage: String? {
            if name.isEmpty || name == currentPurchase?.name {
                return nil
            }
            
            guard Purchase.mockPurchases.first(where: { $0.name == name }) != nil else {
                return nil
            }
            
            return "Это название уже используется, пожалуйста, измените его."
        }
        
        func fetchPurchase(by id: UUID?) {
            guard let id, let purchase = Purchase.mockPurchases.first(where: { $0.id == id }) else {
                return
            }
            
            name = purchase.name
            selectedIcon = purchase.icon
            selectedColor = purchase.color
            
            currentPurchase = purchase
        }
        
        func savePurchase(with id: UUID?, completion: Completion) {
            // TODO добавляем сохранение модели (добавляем или обновляем)
            completion()
        }
    }
}
