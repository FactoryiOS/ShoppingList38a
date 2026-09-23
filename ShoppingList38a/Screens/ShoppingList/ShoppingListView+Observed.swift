//
//  ShoppingListView+Observed.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 19.09.2026.
//

import SwiftUI

extension ShoppingListView {
    @MainActor
    @Observable
    final class Observed {
        var searchText = ""
        var products: [ShoppingItem] = []
        
        private var currentShoppingList: ListItem?
        
        var listTitle: String {
            currentShoppingList?.name ?? "Список покупок"
        }
        
        func fetchShoppingList(by id: UUID) {
            guard let shoppingList = ListItem.mocks.first(where: { $0.id == id }) else {
                currentShoppingList = nil
                products = []
                return
            }
            
            currentShoppingList = shoppingList
            
            products = [
                ShoppingItem(title: "Текст", count: 2, unit: .piece, isPurchased: false),
                ShoppingItem(title: "Текст", count: 2, unit: .piece, isPurchased: false),
                .mockPurchased
            ]
        }
        
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
