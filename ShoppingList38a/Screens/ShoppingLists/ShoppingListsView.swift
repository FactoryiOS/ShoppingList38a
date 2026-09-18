//
//  ShoppingListsView.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 17.09.2026.
//

import SwiftUI

struct ShoppingListsView: View {
    @State private var selectedListID: ListItem.ID?
    
    let lists: [ListItem]
    
    var body: some View {
        Group {
            if lists.isEmpty {
                emptyState
            } else {
                shoppingList
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.primaryBackground
                .ignoresSafeArea()
        }
        .overlay(alignment: .bottom) {
            BaseButton(
                title: "Создать список",
                isActive: true,
                action: {
                    print("Create List")
                }
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .toolbar {
            titleToolbarItem
            contextMenuToolbarItem
        }
        .navigationDestination(item: $selectedListID) { id in
            if let list = lists.first(where: { $0.id == id }) {
                Text(list.title)
            }
        }
    }
    
    private var emptyState: some View {
        // Центрируем плейсхолдер между заголовком и кнопкой.
        // В Figma он привязан к фиксированным отступам,
        // но такая верстка плохо адаптируется к маленьким экранам
        // (например, некорректно выглядит на iPhone SE)
        VStack(spacing: 0) {
            Spacer()
            
            PlaceholderView(
                image: AppImage.emptyShoppingLists,
                title: "Давайте спланируем покупки!",
                subtitle: "Создайте свой первый список"
            )
            
            Spacer()
        }
        // Исключаем из центрирования высоту кнопки 44 pt + нижний отступ 20 pt
        .padding(.bottom, 64)
        .padding(.horizontal, 16)
    }
    
    private var shoppingList: some View {
        List(lists) { list in
            Button {
                selectedListID = list.id
            } label: {
                ListItemView(listItem: list)
            }
            .buttonStyle(.plain)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(
                EdgeInsets(
                    top: 0,
                    leading: 16,
                    bottom: 0,
                    trailing: 0
                )
            )
            .swipeActions(allowsFullSwipe: false) {
                Button(role: .destructive) {
                    print("Delete")
                } label: {
                    Image(systemName: AppSystemIcon.trash)
                        .environment(\.symbolVariants, .none)
                }
                .tint(.systemsRed)
                
                Button {
                    print("Duplicate")
                } label: {
                    Image(systemName: AppSystemIcon.plusSquareOnSquare)
                        .environment(\.symbolVariants, .none)
                }
                .tint(.systemsOrange)
                
                Button {
                    print("Edit")
                } label: {
                    Image(systemName: AppSystemIcon.squareAndPencil)
                        .environment(\.symbolVariants, .none)
                }
                .tint(.systemsGrey)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .listRowSpacing(12)
        .padding(.trailing, 16)
        .padding(.top, 12)
        // Компенсируем 8 pt из-за некорректной высоты NavigationBar в Figma
        .contentMargins(.top, 8, for: .scrollContent)
        // Запас для overscroll, чтобы последняя ячейка прокручивалась выше кнопки
        .contentMargins(.bottom, 86, for: .scrollContent)
    }
    
    @ToolbarContentBuilder
    private var titleToolbarItem: some ToolbarContent {
        if #available(iOS 26.0, *) {
            ToolbarItem(placement: .topBarLeading) {
                Text("Мои списки")
                    .font(AppFont.semiBold28)
                    .foregroundStyle(.titleText)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .sharedBackgroundVisibility(.hidden)
        } else {
            ToolbarItem(placement: .topBarLeading) {
                Text("Мои списки")
                    .font(AppFont.semiBold28)
                    .foregroundStyle(.titleText)
            }
        }
    }
    
    @ToolbarContentBuilder
    private var contextMenuToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
            } label: {
                Image(systemName: AppSystemIcon.ellipsisCircle)
                    .foregroundStyle(.titleText)
                    .frame(width: 44, height: 44)
            }
        }
    }
}

#Preview("Empty") {
    NavigationStack {
        ShoppingListsView(lists: [])
    }
}

#Preview("Data") {
    NavigationStack {
        ShoppingListsView(lists: ListItem.mocks)
    }
}
