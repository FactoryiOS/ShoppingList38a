//
//  PurchaseFormView.swift
//  ShoppingList38a
//
//  Created by Kislov Vadim on 19.09.2026.
//

import SwiftUI

struct PurchaseFormView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
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
            .padding(.top, 12)
        }
        .padding(.horizontal, 16)
        .background(.primaryBackground)
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .bottom) {
            submitButton
        }
        .toolbar {
            titleToolbar
        }
        .onTapGesture {
            isNameFieldFocused = false
        }
        .onAppear {
            observed.fetchPurchase(by: purchaseId)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
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
    
    @ToolbarContentBuilder
    private var titleToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: AppSystemIcon.chevronLeft)
                    .foregroundStyle(colorScheme == .dark ? .white : .blackPrimary )
                    .frame(width: 28, height: 28)
                    .contentShape(Rectangle())
            }
        }
        
        ToolbarItem(placement: .topBarLeading) {
            Text(observed.titleToolbar)
                .font(AppFont.medium17)
                .foregroundStyle(.titleText)
        }
    }
}

#Preview {
    PurchaseFormView(onComplete: { })
}

#Preview {
    PurchaseFormView(purchaseId: ListItem.mocks.first?.id ?? UUID(), onComplete: { })
}
