//
//  ShoppingListView+Observed.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 19.09.2026.
//

import SwiftUI

extension ShoppingListView {
    @Observable
    final class Observed {
        
        var searchText = ""
        
        var products: [ShoppingItem] = [
            .mockUnpurchased,
            .mockUnpurchased,
            .mockPurchased
        ]
        
        func handleAddProductTap() {
            print("Нажата кнопка 'Добавить товар'")
        }
        
        func handleEditProduct(for id: UUID) {
            print("Редактирование товара с ID: \(id)")
        }
        
        func handleDeleteProduct(for id: UUID) {
            if let index = products.firstIndex(where: { $0.id == id }) {
                products.remove(at: index)
            }
        }
        
        func handleToggleCheck(for id: UUID) {
            if let index = products.firstIndex(where: { $0.id == id }) {
                products[index].isPurchased.toggle()
            }
        }
    }
}
