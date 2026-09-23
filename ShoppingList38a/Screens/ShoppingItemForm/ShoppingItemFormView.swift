//
//  ShoppingItemFormView.swift
//  ShoppingList38a
//
//  Created by ivan on 2026-09-22.
//

import SwiftUI

struct ShoppingItemFormView: View {
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var isNameFocused: Bool
    @FocusState private var isAmountFocused: Bool
    @State private var observed: Observed
    
    private let onComplete: Completion
    
    init(
        service: SwiftDataService,
        shoppingList: ShoppingList,
        shoppingItem: ShoppingItem? = nil,
        onComplete: @escaping Completion
    ) {
        _observed = State(
            initialValue: Observed(
                service: service,
                shoppingList: shoppingList,
                shoppingItem: shoppingItem
            )
        )
        
        self.onComplete = onComplete
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            BaseTextField(
                isFocused: $isNameFocused,
                placeholder: "Название товара",
                text: $observed.nameText,
                errorMessage: observed.nameErrorMessage
            )
            
            HStack(spacing: 16) {
                BaseTextField(
                    isFocused: $isAmountFocused,
                    placeholder: "Количество",
                    text: $observed.amountText,
                    errorMessage: nil
                )
                
                selectUnitPicker
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.primaryBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Отменить") {
                    dismiss()
                }
                .font(AppFont.regular17)
                .foregroundStyle(.hintGrey)
            }
            
            ToolbarItem(placement: .principal) {
                Text(observed.title)
                    .font(AppFont.semiBold17)
                    .foregroundStyle(.primaryText)
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Готово") {
                    observed.handleSave(completion: onComplete)
                }
                .font(AppFont.semiBold17)
                .foregroundStyle(
                    observed.isFormValid ? .turquoise : .hintGrey
                )
                .disabled(!observed.isFormValid)
            }
        }
    }
    
    private var selectUnitPicker: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Ед.изм.:")
                    .font(AppFont.regular17)
                    .foregroundStyle(.hintGrey)
                
                Spacer()
                
                Picker("Единица измерения", selection: $observed.selectedUnit) {
                    ForEach(ShoppingItemUnit.allCases, id: \.self) { unit in
                        Text(unit.displayName)
                            .tag(unit)
                    }
                }
                .tint(.turquoise)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color(.baseElementsBackground))
            .cornerRadius(12)
        }
    }
}

#Preview("Create") {
    PreviewEnvironment(.data) { preview in
        NavigationStack {
            ShoppingItemFormView(
                service: preview.service,
                shoppingList: preview.shoppingList,
                onComplete: { }
            )
        }
    }
}

#Preview("Edit") {
    PreviewEnvironment(.data) { preview in
        NavigationStack {
            ShoppingItemFormView(
                service: preview.service,
                shoppingList: preview.shoppingList,
                shoppingItem: preview.shoppingItem,
                onComplete: { }
            )
        }
    }
}
