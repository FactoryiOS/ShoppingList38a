//
//  PurchaseIcon+ImageResource.swift
//  ShoppingList38a
//
//  Created by Kislov Vadim on 15.09.2026.
//

import SwiftUI

extension PurchaseIcon {
    var resource: ImageResource {
        switch self {
        case .snow: .snowOutline24
        case .airplane: .airplaneOutline24
        case .alert: .alertOutline24
        case .balloon: .balloonOutline24
        case .bandage: .bandageOutline24
        case .barbell: .barbellOutline24
        case .bed: .bedOutline24
        case .briefcase: .briefcaseOutline24
        case .build: .buildOutline24
        case .business: .businessOutline24
        case .calendarNumber: .calendarNumberOutline24
        case .gift: .giftOutline24
        case .colorPalette: .colorPaletteOutline24
        case .cart: .cartOutline24
        case .car: .carOutline24
        case .fastFood: .fastFoodOutline24
        case .paw: .pawOutline24
        case .gameController: .gameControllerOutline24
        }
    }
}
