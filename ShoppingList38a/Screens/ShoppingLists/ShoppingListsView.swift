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
        ZStack(alignment: .bottom) {
            Color.primaryBackground
                .ignoresSafeArea()
            
            Group {
                if lists.isEmpty {
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
                } else {
                    List(lists) { list in
                        Button {
                            selectedListID = list.id
                        } label: {
                            ListItemView(listItem: list)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(.zero))
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
                    .padding(.top, 12)
                    // Компенсируем 8 pt из-за некорректной высоты NavigationBar в Figma
                    .contentMargins(.top, 8, for: .scrollContent)
                    // Запас для overscroll, чтобы последняя ячейка прокручивалась выше кнопки
                    .contentMargins(.bottom, 86, for: .scrollContent)
                }
            }
            .padding(.horizontal, 16)
            
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
            ToolbarItem(placement: .topBarLeading) {
                Text("Мои списки")
                    .font(AppFont.semiBold28)
                    .foregroundStyle(.titleText)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    
                } label: {
                    Image(systemName: AppSystemIcon.ellipsisCircle)
                        .foregroundStyle(.titleText)
                        .frame(width: 44, height: 44)
                }
            }
        }
        .navigationDestination(item: $selectedListID) { id in
            if let list = lists.first(where: { $0.id == id }) {
                Text(list.title)
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
