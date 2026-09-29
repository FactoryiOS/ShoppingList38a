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

    private let onComplete: () -> Void

    init(
        service: SwiftDataService,
        shoppingList: ShoppingList,
        shoppingItem: ShoppingItem? = nil,
        onComplete: @escaping () -> Void
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
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 0) {
                    BaseTextField(
                        text: $observed.nameText,
                        isFocused: $isNameFocused,
                        placeholder: .shoppingItemNamePlaceholder,
                        errorMessage: observed.nameErrorMessage
                    )

                    if isNameFocused && !observed.suggestions.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(observed.suggestions, id: \.self) { suggestion in
                                Button(
                                    action: {
                                        observed.nameText = suggestion
                                        isAmountFocused = true
                                    },
                                    label: {
                                        HStack {
                                            Text(suggestion)
                                                .font(AppFont.regular17)
                                                .foregroundStyle(.primaryText)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 16)
                                        .frame(height: 44)
                                    }
                                )
                                .overlay(alignment: .bottom) {
                                    if suggestion != observed.suggestions.last {
                                        Divider()
                                            .overlay(.borderGrey)
                                            .padding(.horizontal, 16)
                                    }
                                }
                            }
                        }
                        .background(.baseElementsBackground)
                        .cornerRadius(12)
                        .padding(.top, 10)
                        .transition(
                            .opacity.combined(
                                with: .offset(y: -6)
                            )
                        )
                    }
                }

                HStack(spacing: 16) {
                    BaseTextField(
                        text: $observed.amountText,
                        isFocused: $isAmountFocused,
                        placeholder: .shoppingItemQuantityPlaceholder,
                        errorMessage: nil
                    )
                    .keyboardType(.numberPad)

                    selectUnitPicker
                        .simultaneousGesture(
                            TapGesture()
                                .onEnded {
                                    isNameFocused = false
                                    isAmountFocused = false
                                }
                        )
                }
            }
            .animation(
                .easeInOut(duration: 0.2),
                value: observed.nameErrorMessage != nil
            )
            .animation(
                .easeInOut(duration: 0.2),
                value: isNameFocused && !observed.suggestions.isEmpty
            )
            .animation(
                .easeInOut(duration: 0.2),
                value: observed.suggestions.count
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .background {
            Color.primaryBackground
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    isNameFocused = false
                    isAmountFocused = false
                }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            observed.loadAllExistingItems()
        }
        .toolbar {
            formToolbar
        }
    }

    private var selectUnitPicker: some View {
        HStack {
            Text(.unitLabel)
                .font(AppFont.regular17)
                .foregroundStyle(.hintGrey)

            Spacer()

            Picker(.unitPickerTitle, selection: $observed.selectedUnit) {
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
        .background(.baseElementsBackground)
        .cornerRadius(12)
    }

    @ToolbarContentBuilder
    private var formToolbar: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button(.cancel) {
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
            Button(.done) {
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
