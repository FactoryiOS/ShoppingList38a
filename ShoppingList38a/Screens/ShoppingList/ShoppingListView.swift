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

        static var searchPlaceholder: String {
            String(localized: "Search")
        }

        static var addButtonTitle: String {
            String(localized: "Add Item")
        }

        static var emptyStateTitle: String {
            String(localized: "Let's plan your shopping!")
        }

        static var emptyStateSubTitle: String {
            String(localized: "Start adding items")
        }

        static var contextMenuSortByAlphabet: String {
            String(localized: "Sort Alphabetically")
        }

        static var contextMenuShare: String {
            String(localized: "Share")
        }

        static var contextMenuResetPurchased: String {
            String(localized: "Uncheck All Items")
        }

        static var contextMenuDeletePurchased: String {
            String(localized: "Delete Purchased Items")
        }

        static var deleteShoppingItemAlertTitle: String {
            String(localized: "Delete Item")
        }

        static var deleteShoppingItemAlertMessage: String {
            String(localized: "Are you sure you want to delete this item?")
        }

        static var deletePurchasedItemsAlertTitle: String {
            String(localized: "Delete Purchased Items?")
        }

        static var deletePurchasedItemsAlertMessage: String {
            String(localized: "Are you sure you want to delete all purchased items?")
        }

    }
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var router
    
    @State private var observed: Observed
    
    @FocusState private var isSearchFocused: Bool
    
    @State private var showDeletePurchasedItemsAlert = false
    @State private var showDeleteShoppingItemAlert = false
    @State private var shoppingItemToDelete: ShoppingItem?
    
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
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .background(.primaryBackground)

            if observed.items.isEmpty {
                emptyState
                addButton
            } else {
                shoppingListState
                    .padding(.top, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.primaryBackground
                .ignoresSafeArea()
        }
        .overlay(alignment: .bottom) {
            if !observed.items.isEmpty {
                addButton
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .deleteAlert(
            title: ShoppingListTexts.deleteShoppingItemAlertTitle,
            message: ShoppingListTexts.deleteShoppingItemAlertMessage,
            isPresented: $showDeleteShoppingItemAlert,
            onCancel: {
                shoppingItemToDelete = nil
            },
            onDelete: {
                guard let item = shoppingItemToDelete else {
                    return
                }
                
                shoppingItemToDelete = nil
                
                withAnimation {
                    observed.handleDeleteShoppingItem(item)
                }
            }
        )
        .deleteAlert(
            title: ShoppingListTexts.deletePurchasedItemsAlertTitle,
            message: ShoppingListTexts.deletePurchasedItemsAlertMessage,
            isPresented: $showDeletePurchasedItemsAlert,
            onDelete: {
                withAnimation {
                    observed.handleDeletePurchasedItems()
                }
            }
        )
        .toolbar {
            titleToolbarItem
            contextMenuToolbarItem
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    private var emptyState: some View {
        ScrollView {
            VStack(spacing: .zero) {
                Spacer()
                
                PlaceholderView(
                    image: AppImage.emptyShoppingList,
                    title: ShoppingListTexts.emptyStateTitle,
                    subtitle: ShoppingListTexts.emptyStateSubTitle
                )
                
                Spacer()
            }
            .containerRelativeFrame(.vertical)
            .contentShape(Rectangle())
            .onTapGesture {
                isSearchFocused = false
            }
        }
        .scrollDisabled(true)
        .scrollIndicators(.hidden)
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
            .contentShape(Rectangle())
            .onTapGesture {
                isSearchFocused = false
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
        .scrollDismissesKeyboard(.immediately)
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
            .focused($isSearchFocused)
            
            if !observed.searchText.isEmpty {
                Button {
                    observed.searchText = ""
                    isSearchFocused = false
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
            Button {
                shoppingItemToDelete = item
                showDeleteShoppingItemAlert = true
            } label: {
                Image(systemName: AppSystemIcon.trash)
                    .environment(\.symbolVariants, .none)
            }
            .tint(.systemsRed)
            
            Button {
                isSearchFocused = false
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
                isSearchFocused = false
                
                router.showModal(
                    .createShoppingItem(observed.shoppingListID)
                )
            }
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
    
    @ToolbarContentBuilder
    private var titleToolbarItem: some ToolbarContent {
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
    private var contextMenuToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Toggle(
                    isOn: Binding(
                        get: {
                            observed.isSortedByAlphabet
                        },
                        set: { newValue in
                            withAnimation {
                                observed.isSortedByAlphabet = newValue
                            }
                        }
                    )
                ) {
                    Label(
                        ShoppingListTexts.contextMenuSortByAlphabet,
                        systemImage: AppSystemIcon.arrowUpArrowDown
                    )
                }
                
                ShareLink(
                    item: observed.shareText,
                    subject: Text(observed.listTitle)
                ) {
                    Label(
                        ShoppingListTexts.contextMenuShare,
                        systemImage: AppSystemIcon.squareAndArrowUp
                    )
                }
                
                Button {
                    observed.handleResetPurchasedItems()
                } label: {
                    Label(
                        ShoppingListTexts.contextMenuResetPurchased,
                        systemImage: AppSystemIcon.arrow2Circlepath
                    )
                }
                
                Button(role: .destructive) {
                    showDeletePurchasedItemsAlert = true
                } label: {
                    Label(
                        ShoppingListTexts.contextMenuDeletePurchased,
                        systemImage: AppSystemIcon.trash
                    )
                }
                
            } label: {
                Image(systemName: AppSystemIcon.ellipsisCircle)
                    .foregroundStyle(.titleText)
                    .frame(width: 44, height: 44)
            }
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        isSearchFocused = false
                    }
                )
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
