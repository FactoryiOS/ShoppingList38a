//
//  ShoppingListsView.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 17.09.2026.
//

import SwiftData
import SwiftUI

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
                title: .createList,
                isActive: true,
                action: {
                    router.showModal(.createShoppingList)
                }
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .deleteAlert(
            title: .deleteListTitle,
            message: .deleteListMessage,
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
            titleToolbar
            contextMenuToolbar
        }
    }

    private var emptyState: some View {
        VStack(spacing: 0) {
            Spacer()

            PlaceholderView(
                image: AppImage.emptyShoppingLists,
                title: .emptyStateTitle,
                subtitle: .shoppingListsEmptyStateSubtitle
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
    private var titleToolbar: some ToolbarContent {
        if #available(iOS 26.0, *) {
            ToolbarItem(placement: .topBarLeading) {
                Text(.shoppingListsTitle)
                    .font(AppFont.semiBold28)
                    .foregroundStyle(.titleText)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .sharedBackgroundVisibility(.hidden)
        } else {
            ToolbarItem(placement: .topBarLeading) {
                Text(.shoppingListsTitle)
                    .font(AppFont.semiBold28)
                    .foregroundStyle(.titleText)
            }
        }
    }

    @ToolbarContentBuilder
    private var contextMenuToolbar: some ToolbarContent {
        @Bindable var appState = appState

        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Picker(
                    .themePickerTitle,
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
                        .sortAlphabetically,
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
