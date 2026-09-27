//
//  ShoppingListsView.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 17.09.2026.
//

import SwiftUI
import SwiftData

struct ShoppingListsView: View {
    @Environment(AppState.self) private var appState
    @Environment(AppRouter.self) private var router
    
    @State private var observed: Observed
    @State private var showDeleteShoppingListAlert = false
    @State private var shoppingListToDelete: ShoppingList?
    
    @Query(
        sort: \ShoppingList.createdAt,
        order: .forward
    )
    private var lists: [ShoppingList]
    
    init(service: SwiftDataService) {
        _observed = State(
            initialValue: Observed(
                service: service
            )
        )
    }

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
                    router.showModal(.createShoppingList)
                }
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .deleteAlert(
            title: "Удаление списка",
            message: "Вы действительно хотите удалить список?",
            isPresented: $showDeleteShoppingListAlert,
            onCancel: {
                shoppingListToDelete = nil
            },
            onDelete: {
                guard let list = shoppingListToDelete else {
                    return
                }
                
                shoppingListToDelete = nil
                
                withAnimation {
                    observed.handleDeleteShoppingList(list)
                }
            }
        )
        .toolbar {
            titleToolbarItem
            contextMenuToolbarItem
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
        List(observed.sortLists(lists)) { list in
            Button {
                router.push(.shoppingList(list.id))
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
                Button {
                    shoppingListToDelete = list
                    showDeleteShoppingListAlert = true
                } label: {
                    Image(systemName: AppSystemIcon.trash)
                        .environment(\.symbolVariants, .none)
                }
                .tint(.systemsRed)
                
                Button {
                    withAnimation {
                        observed.handleDuplicateShoppingList(list)
                    }
                } label: {
                    Image(systemName: AppSystemIcon.plusSquareOnSquare)
                        .environment(\.symbolVariants, .none)
                }
                .tint(.systemsOrange)
                
                Button {
                    router.showModal(.editShoppingList(list.id))
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
        @Bindable var appState = appState
        
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Picker(
                    "Установить тему",
                    systemImage: AppSystemIcon.circleLefthalfFilledInverse,
                    selection: $appState.appColorScheme
                ) {
                    ForEach(AppColorScheme.allCases) { scheme in
                        Text(scheme.displayName)
                            .tag(scheme as AppColorScheme?)
                    }
                }
                .pickerStyle(.menu)
                
                Divider()
                
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
                        "Сортировать по алфавиту",
                        systemImage: AppSystemIcon.arrowUpArrowDown
                    )
                }
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
            ShoppingListsView(
                service: preview.service
            )
        }
    }
}

#Preview("Data") {
    PreviewEnvironment(.data) { preview in
        NavigationStack {
            ShoppingListsView(
                service: preview.service
            )
        }
    }
}
