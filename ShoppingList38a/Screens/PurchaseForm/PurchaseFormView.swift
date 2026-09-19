//
//  PurchaseFormView.swift
//  ShoppingList38a
//
//  Created by Kislov Vadim on 19.09.2026.
//

import SwiftUI

struct PurchaseFormView: View {
    @FocusState private var isNameFieldFocused: Bool
    @State private var observed = Observed()
    
    private let purchaseId: UUID?
    private let onComplete: Completion
    
    init(purchaseId: UUID? = nil, onComplete: @escaping Completion) {
        self.purchaseId = purchaseId
        self.onComplete = onComplete
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                BaseTextField(
                    isFocused: $isNameFieldFocused,
                    placeholder: "Введите название списка",
                    text: $observed.name,
                    errorMessage: observed.nameErrorMessage
                )
                
                ColorSelectorView(selectedColor: $observed.selectedColor)
                
                IconSelectorView(
                    selectedIcon: $observed.selectedIcon,
                    selectedColor: observed.selectedColor
                )
            }
        }
        .padding(.horizontal, 16)
        .background(.primaryBackground)
        .scrollIndicators(.hidden)
        
        .overlay(alignment: .bottom) {
            submitButton
        }
        .onTapGesture {
            isNameFieldFocused = false
        }
        .onAppear {
            observed.fetchPurchase(by: purchaseId)
        }
    }
    
    private var submitButton: some View {
        BaseButton(
            title: observed.submitButtonTitle,
            isActive: observed.isValid,
            action: {
                observed.savePurchase(with: purchaseId, completion: onComplete)
            }
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
}

#Preview {
    PurchaseFormView(onComplete: { })
}

#Preview {
    PurchaseFormView(purchaseId: Purchase.mockUUID, onComplete: { })
}
