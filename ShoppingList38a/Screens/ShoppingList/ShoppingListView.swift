//
//  ShoppingListView.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 19.09.2026.
//

import SwiftData
import SwiftUI

struct ShoppingListView: View {
    private enum ShoppingListTexts {
        static let searchPlaceholder = "Поиск"
        static let addButtonTitle = "Добавить товар"
        static let emptyStateTitle = "Давайте спланируем покупки!"
        static let emptyStateSubTitle = "Начните добавлять товары"
    }
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var router
    
    @State private var observed: Observed
    
    init(
        service: SwiftDataService,
        shoppingList: ShoppingList
    ) {
        _observed = State(
            initialValue: Observed(
                service: service,
                shoppingList: shoppingList
            )
        )
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            customSearchBar
                .padding([.horizontal, .bottom], 16)
                .padding(.top, 4)
                .background(.primaryBackground)
            Group {
                if observed.items.isEmpty {
                    emptyState
                } else {
                    shoppingListState
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.primaryBackground
                .ignoresSafeArea()
        }
        .overlay(alignment: .bottom) {
            addButton
        }
        .toolbar {
            titleToolbar
            trailingToolbar
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    private var emptyState: some View {
        VStack(spacing: 0) {
            Spacer()
            PlaceholderView(
                image: AppImage.emptyShoppingList,
                title: ShoppingListTexts.emptyStateTitle,
                subtitle: ShoppingListTexts.emptyStateSubTitle
            )
            Spacer()
        }
        .padding(.bottom, 64)
    }
    
    private var shoppingListState: some View {
        VStack(spacing: .zero) {
            shoppingList
        }
    }
    
    private var shoppingList: some View {
        List(observed.filteredItems) { item in
            VStack(spacing: .zero) {
                ShoppingItemView(
                    shoppingItem: item,
                    onTogglePurchased: {
                        observed.handleToggleShoppingItem(item)
                    }
                )
                
                Divider()
                    .background(.borderGrey)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .swipeActions(allowsFullSwipe: false) {
                swipeButtons(for: item)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .contentMargins(.bottom, 86, for: .scrollContent)
    }
    
    private var customSearchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: AppSystemIcon.magnifyingGlass)
                .foregroundStyle(.hintGrey)
            
            TextField(
                ShoppingListTexts.searchPlaceholder,
                text: $observed.searchText,
                prompt: Text(ShoppingListTexts.searchPlaceholder)
                    .foregroundStyle(.hintGrey)
            )
            .font(AppFont.regular17)
            .foregroundStyle(.primaryText)
            
            if !observed.searchText.isEmpty {
                Button {
                    observed.searchText = ""
                } label: {
                    Image(systemName: AppSystemIcon.xmarkCircleFill)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.clearIconForeground, .hintGrey)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 38)
        .background(.searchBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private func swipeButtons(for item: ShoppingItem) -> some View {
        Group {
            Button(role: .destructive) {
                observed.handleDeleteShoppingItem(item)
            } label: {
                Image(systemName: AppSystemIcon.trash)
                    .environment(\.symbolVariants, .none)
            }
            .tint(.systemsRed)
            
            Button {
                router.showModal(
                    .editShoppingItem(item.id)
                )
            } label: {
                Image(systemName: AppSystemIcon.squareAndPencil)
                    .environment(\.symbolVariants, .none)
            }
            .tint(.systemsGrey)
        }
    }
    
    private var addButton: some View {
        BaseButton(
            title: ShoppingListTexts.addButtonTitle,
            isActive: true,
            action: {
                router.showModal(
                    .createShoppingItem(observed.shoppingListID)
                )
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
            
            Text(observed.listTitle)
                .font(AppFont.medium17)
                .foregroundStyle(.titleText)
        }
    }
    
    @ToolbarContentBuilder
    private var trailingToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                // Экшен для троеточия
            } label: {
                Image(systemName: AppSystemIcon.ellipsisCircle)
                    .foregroundStyle(.titleText)
                    .frame(width: 44, height: 44)
            }
        }
    }
}

#Preview("Empty") {
    PreviewEnvironment(.empty) { preview in
        NavigationStack {
            ShoppingListView(
                service: preview.service,
                shoppingList: ShoppingList(
                    name: "Новый год",
                    icon: .calendarNumber,
                    color: .blue
                )
            )
        }
    }
}

#Preview("Data") {
    PreviewEnvironment(.data) { preview in
        NavigationStack {
            ShoppingListView(
                service: preview.service,
                shoppingList: preview.shoppingList
            )
        }
    }
}
