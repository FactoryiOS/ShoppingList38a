//
//  IconSelectorView.swift
//  ShoppingList38a
//
//  Created by Kislov Vadim on 15.09.2026.
//

import SwiftUI

struct IconSelectorView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var selectedIcon: PurchaseIcon?
    
    var selectedColor: PurchaseColor?
    
    private var iconRowCount: Int {
        Int(ceil(Double(PurchaseIcon.allCases.count) / Double(Constants.iconsPerRow)))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Выберите дизайн")
                .font(AppFont.regular16)
                .foregroundStyle(.primaryText)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0..<iconRowCount, id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(getIconIndexRange(for: row), id: \.self) { index in
                            let icon = PurchaseIcon.allCases[index]
                            
                            Button {
                                selectedIcon = icon
                            } label: {
                                Image(icon.resource)
                                    .frame(width: 48, height: 48)
                                    .foregroundStyle(getForegroundColor(for: icon))
                                    .background(getBackgroundColor(for: icon), in: Circle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.baseElementsBackground, in: RoundedRectangle(cornerRadius: 12))
    }
    
    private func getForegroundColor(for icon: PurchaseIcon) -> Color {
        colorScheme == .dark || icon == selectedIcon ? .blackPrimary : .white
    }
    
    private func getBackgroundColor(for icon: PurchaseIcon) -> Color {
        icon == selectedIcon
        ? (selectedColor?.color ?? .additionalBlue)
        : .iconBackground
    }
    
    private func getIconIndexRange(for row: Int) -> Range<Int> {
        let startIndex = row * Constants.iconsPerRow
        
        return startIndex..<min(startIndex + Constants.iconsPerRow, PurchaseIcon.allCases.count)
    }
}

private extension IconSelectorView {
    enum Constants {
        static let iconsPerRow = 6
    }
}

#Preview {
    @Previewable @State var selectedIcon: PurchaseIcon? = .car
    @Previewable @State var selectedColor: PurchaseColor? = .red
    
    VStack {
        ColorSelectorView(selectedColor: $selectedColor)
        
        IconSelectorView(selectedIcon: $selectedIcon, selectedColor: selectedColor)
    }
    .padding(.horizontal, 16)
}
