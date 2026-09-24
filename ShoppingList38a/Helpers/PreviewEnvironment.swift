//
//  PreviewEnvironment.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 21.09.2026.
//

#if DEBUG

import SwiftUI
import SwiftData

@MainActor
struct PreviewContext {
    enum State {
        case empty
        case data
    }

    let service: SwiftDataService
    let appState: AppState
    let appRouter: AppRouter

    fileprivate let modelContainer: ModelContainer

    private let storedShoppingList: ShoppingList?
    private let storedUnpurchasedItem: ShoppingItem?
    private let storedPurchasedItem: ShoppingItem?

    var shoppingList: ShoppingList {
        guard let storedShoppingList else {
            fatalError("ShoppingList is unavailable in empty preview")
        }

        return storedShoppingList
    }

    var unpurchasedItem: ShoppingItem {
        guard let storedUnpurchasedItem else {
            fatalError("ShoppingItem is unavailable in empty preview")
        }

        return storedUnpurchasedItem
    }

    var purchasedItem: ShoppingItem {
        guard let storedPurchasedItem else {
            fatalError("ShoppingItem is unavailable in empty preview")
        }

        return storedPurchasedItem
    }
    
    var shoppingItem: ShoppingItem {
        guard let shoppingItem = storedShoppingList?.items.first else {
            fatalError("ShoppingItem is unavailable in empty preview")
        }

        return shoppingItem
    }

    init(_ state: State) {
        let configuration = ModelConfiguration(
            isStoredInMemoryOnly: true
        )

        let container: ModelContainer

        do {
            container = try ModelContainer(
                for: ShoppingList.self,
                ShoppingItem.self,
                configurations: configuration
            )
        } catch {
            fatalError("Failed to create preview ModelContainer: \(error)")
        }

        let service = SwiftDataService(
            modelContainer: container
        )

        modelContainer = container
        self.service = service
        
        appState = AppState(
            swiftDataService: service
        )
        
        appRouter = AppRouter()

        switch state {
        case .empty:
            storedShoppingList = nil
            storedUnpurchasedItem = nil
            storedPurchasedItem = nil

        case .data:
            let lists = ShoppingList.mocks
            let unpurchasedItem = ShoppingItem.mockUnpurchased
            let purchasedItem = ShoppingItem.mockPurchased

            lists.forEach {
                container.mainContext.insert($0)
            }

            container.mainContext.insert(unpurchasedItem)
            container.mainContext.insert(purchasedItem)

            do {
                try container.mainContext.save()
            } catch {
                fatalError("Failed to save preview data: \(error)")
            }

            storedShoppingList = lists.first
            storedUnpurchasedItem = unpurchasedItem
            storedPurchasedItem = purchasedItem
        }
    }
}

@MainActor
struct PreviewEnvironment<Content: View>: View {
    private let context: PreviewContext
    private let content: (PreviewContext) -> Content

    init(
        _ state: PreviewContext.State = .data,
        @ViewBuilder content: @escaping (PreviewContext) -> Content
    ) {
        let context = PreviewContext(state)

        self.context = context
        self.content = content
    }

    var body: some View {
        content(context)
            .environment(context.appState)
            .environment(context.appRouter)
            .preferredColorScheme(
                context.appState.appColorScheme?.preferredColorScheme
            )
            .modelContainer(context.modelContainer)
    }
}

#endif
