//
//  BaseTextFieldModel.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 15.09.2026.
//
import SwiftUI

struct BaseTextFieldModel {
    let placeholder: String
    let defaultText: String
    private let errorText: String?
    
    func errorMessage(for currentText: String) -> String? {
        return currentText == defaultText ? errorText : nil
    }
    
    static let duplicateError = BaseTextFieldModel(
        placeholder: "Введите название",
        defaultText: "Новый год",
        errorText: "Это название уже используется, пожалуйста, измените его."
    )
    
}
