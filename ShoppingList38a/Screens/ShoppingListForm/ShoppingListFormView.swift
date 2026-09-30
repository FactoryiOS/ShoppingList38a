//
//  ShoppingListFormView.swift
//  ShoppingList38a
//
//  Created by Kislov Vadim on 19.09.2026.
//

import SwiftUI

struct ShoppingListFormView: View {
    @Environment(\.dismiss) private var dismiss

    @FocusState private var isNameFieldFocused: Bool

    @State private var observed: Observed

    private let onComplete: () -> Void

    init(
        service: SwiftDataService,
        shoppingList: ShoppingList? = nil,
        onComplete: @escaping () -> Void
    ) {
        _observed = State(
            initialValue: Observed(
                service: service,
                shoppingList: shoppingList
            )
        )

        self.onComplete = onComplete
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                BaseTextField(
                    text: $observed.name,
                    isFocused: $isNameFieldFocused,
                    placeholder: .shoppingListNamePlaceholder,
                    errorMessage: observed.nameErrorMessage
                )
                
                ColorSelectorView(
                    selectedColor: $observed.selectedColor
                )
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            isNameFieldFocused = false
                        }
                )
                
                IconSelectorView(
                    selectedIcon: $observed.selectedIcon,
                    selectedColor: observed.selectedColor
                )
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            isNameFieldFocused = false
                        }
                )
            }
            .padding(.top, 12)
            .animation(
                .easeInOut(duration: 0.2),
                value: observed.nameErrorMessage != nil
            )
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
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    private var submitButton: some View {
        BaseButton(
            title: observed.submitButtonTitle,
            isActive: observed.isFormValid,
            action: {
                observed.handleSave(completion: onComplete)
            }
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }

    @ToolbarContentBuilder
    private var titleToolbar: some ToolbarContent {
        if #available(iOS 26.0, *) {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 8) {
                    backButton
                    toolbarTitle
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .sharedBackgroundVisibility(.hidden)
        } else {
            ToolbarItemGroup(placement: .topBarLeading) {
                backButton
                toolbarTitle
            }
        }
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: AppSystemIcon.chevronLeft)
                .foregroundStyle(.titleText)
                .frame(width: 28, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var toolbarTitle: some View {
        Text(observed.toolbarTitle)
            .font(AppFont.medium17)
            .foregroundStyle(.titleText)
    }
}

#Preview("Create") {
    PreviewEnvironment(.empty) { preview in
        NavigationStack {
            ShoppingListFormView(
                service: preview.service,
                onComplete: { }
            )
        }
    }
}

#Preview("Edit") {
    PreviewEnvironment(.data) { preview in
        NavigationStack {
            ShoppingListFormView(
                service: preview.service,
                shoppingList: preview.shoppingList,
                onComplete: { }
            )
        }
    }
}
