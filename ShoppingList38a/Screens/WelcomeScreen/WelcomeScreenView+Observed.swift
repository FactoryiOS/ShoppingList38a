//
//  WelcomeScreenView+Observed.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 18.09.2026.
//

import SwiftUI

extension WelcomeScreenView {
    @Observable
    @MainActor
    final class Observed {
        private let onStartButtonTap: () -> Void

        init(onStartButtonTap: @escaping () -> Void = {}) {
            self.onStartButtonTap = onStartButtonTap
        }

        func handleStartButtonTap() {
            onStartButtonTap()
        }
    }
}
