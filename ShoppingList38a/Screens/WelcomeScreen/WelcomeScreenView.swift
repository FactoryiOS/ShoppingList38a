//
//  WelcomeScreenView.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 16.09.2026.
//

import SwiftUI

struct WelcomeScreenView: View {
    var onComplete: () -> Void = {}

    var body: some View {
        VStack(spacing: .zero) {
            VStack(spacing: .zero) {
                Spacer()

                welcomeContent

                Spacer()
            }

            actionButton
        }
        .padding(.horizontal, 16)
        .background(.primaryBackground)
    }

    private var welcomeContent: some View {
        VStack(spacing: 48) {
            titleView
            imageView
            descriptionView
        }
    }

    private var titleView: some View {
        Text(.welcomeTitle)
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
            Text(.welcomeHeadline)
                .font(AppFont.semiBold22)

            Text(.welcomeDescription)
                .font(AppFont.regular17)
        }
        .foregroundStyle(.primaryText)
        .multilineTextAlignment(.center)
    }

    private var actionButton: some View {
        BaseButton(
            title: .welcomeStartButton,
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
