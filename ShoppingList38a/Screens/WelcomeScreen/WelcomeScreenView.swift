//
//  WelcomeScreenView.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 16.09.2026.
//

import SwiftUI

struct WelcomeScreenView: View {
    private enum WelcomeTexts {
        static let largeTitle = "Добро пожаловать!"
        static let headLineTitle = "Никогда не забывайте,\nчто нужно купить"
        static let supportingTextTitle = "Создавайте списки\nи не переживайте о покупках"
        static let startButtonTitle = "Начать"
    }

    var onComplete: () -> Void = {}

    var body: some View {
        VStack(spacing: .zero) {
            VStack(spacing: 48) {
                titleView
                imageView
                descriptionView
            }
            .padding(.top, 40)

            Spacer()

            actionButton
        }
        .padding(.horizontal, 16)
        .background(.primaryBackground)
    }

    private var titleView: some View {
        Text(WelcomeTexts.largeTitle)
            .font(AppFont.regular34)
            .foregroundStyle(.titleText)
            .multilineTextAlignment(.center)
    }

    private var imageView: some View {
        Image(AppImage.welcomeScreenImage)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: 285)
    }

    private var descriptionView: some View {
        VStack(spacing: 12) {
            Text(WelcomeTexts.headLineTitle)
                .font(AppFont.semiBold22)

            Text(WelcomeTexts.supportingTextTitle)
                .font(AppFont.regular17)
        }
        .foregroundStyle(.primaryText)
        .multilineTextAlignment(.center)
    }

    private var actionButton: some View {
        BaseButton(
            title: WelcomeTexts.startButtonTitle,
            isActive: true,
            action: onComplete
        )
        .padding(.bottom, 20)
    }
}

#Preview("Светлая тема") {
    WelcomeScreenView()
        .preferredColorScheme(.light)
}

#Preview("Темная тема") {
    WelcomeScreenView()
        .preferredColorScheme(.dark)
}
