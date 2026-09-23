//
//  ShoppingItemFormView.swift
//  ShoppingList38a
//
//  Created by ivan on 2026-09-22.
//

import SwiftUI

struct ShoppingItemFormView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var isFocused: Bool
    @State private var observed: Observed
    
    init(mode: ProductFormType) {
        _observed = State(initialValue: Observed(mode: mode))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                BaseTextField(
                    isFocused: $isFocused,
                    placeholder: "Название списка",
                    text: $observed.nameText,
                    errorMessage: observed.currentError
                )
                
                HStack(spacing: 16) {
                    BaseTextField(
                        isFocused: $isFocused,
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
                        print("done")
                    }
                    .font(AppFont.semiBold17)
                    .foregroundStyle(
                        observed.isFormValid ? .turquoise : .hintGrey
                    )
                    .disabled(!observed.isFormValid)
                }
            }

        }
    }
    
    private var selectUnitPicker: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Ед.изм.:")
                    .font(AppFont.regular17)
                    .foregroundStyle(.hintGrey)
                // заметил что текст стандартный текст плейсхолдера не соответствует макету
                Spacer()
                Picker("skdjfskdf", selection: $observed.selectedUnit) {
                    ForEach(ShoppingItemUnit.allCases, id: \.self) { unit in
                        Text(unit.displayName)
                        // по макету "шт" должно быть без "." но у нас в ShoppingItemUnit с "."
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
    ShoppingItemFormView(mode: .create)
}

#Preview("Edit") {
    let item = ShoppingItem.mockPurchased
    ShoppingItemFormView(mode: .edit(item))
}
