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

    private let onComplete: Completion
    
    init(
        service: SwiftDataService,
        shoppingList: ShoppingList? = nil,
        onComplete: @escaping Completion
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
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private var submitButton: some View {
        BaseButton(
            title: observed.submitButtonTitle,
            isActive: observed.isValid,
            action: {
                observed.handleSave(completion: onComplete)
            }
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
    
    @ToolbarContentBuilder
    private var titleToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: AppSystemIcon.chevronLeft)
                    .foregroundStyle(.titleText)
                    .frame(width: 28, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            Text(observed.titleToolbar)
                .font(AppFont.medium17)
                .foregroundStyle(.titleText)
        }
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
