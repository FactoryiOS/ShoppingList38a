//
//  ProductFormView+Observed.swift
//  ShoppingList38a
//
//  Created by ivan on 2026-09-23.
//

import Foundation

extension ShoppingItemFormView {
    @MainActor
    @Observable
    final class Observed {
        let mode: ProductFormType
        
        var item: ShoppingItem?
        
        var title: String {
            mode.displayName
        }
        
        var nameText: String
        
        var currentError: String? {
            nameText == "Новый год" // как тут получать все существующие названия ?
            ? "Этот товар уже есть в списке, добавьте другой"
            : nil
        }
        
        var amountText: String
        
        var selectedUnit: ShoppingItemUnit
        
        var isFormValid: Bool {
            nameText != "" && amountText != ""
        }
        
        init(mode: ProductFormType) {
            self.mode = mode
            
            switch mode {
            case .create:
                self.nameText = ""
                self.amountText = ""
                self.selectedUnit = .piece
            case .edit(let item):
                self.nameText = item.title
                self.amountText = "\(item.count)"
                self.selectedUnit = item.unit
            }
        }
    }
}
