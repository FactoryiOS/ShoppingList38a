//
//  BaseButtonModel.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 15.09.2026.
//

import SwiftUI

struct BaseButtonModel: Identifiable {
    let id = UUID()
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    static let mocks: [BaseButtonModel] = [
        BaseButtonModel(title: "Создать", isActive: false, action: {}),
        BaseButtonModel(title: "Создать", isActive: true, action: {})
    ]
}
