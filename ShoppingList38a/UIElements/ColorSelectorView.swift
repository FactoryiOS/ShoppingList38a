//
//  ColorSelectorView.swift
//  ShoppingList38a
//
//  Created by Anastasia Belyakova on 15.09.2026.
//

import SwiftUI

struct ColorSelectorView: View {
    @Binding var selectedColor: PurchaseColor?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Выберите цвет")
                .font(AppFont.regular16)
                .foregroundStyle(.primaryText)
                .padding(.horizontal, 12)

            HStack {
                ForEach(PurchaseColor.allCases, id: \.self) { purchaseColor in
                    if purchaseColor != PurchaseColor.allCases.first {
                        Spacer()
                    }
                    
                    colorButton(for: purchaseColor)
                }
            }
            .padding(.horizontal, 27.5)
        }
        .padding(.top, 12)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 105)
        .background(.baseElementsBackground, in: RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
    }
    
    private func colorButton(for purchaseColor: PurchaseColor) -> some View {
        Button {
            selectedColor = purchaseColor
        } label: {
            ZStack {
                if selectedColor == purchaseColor {
                    Circle()
                        .strokeBorder(.turquoise, lineWidth: 2)
                        .frame(width: 52, height: 52)
                }
                
                Circle()
                    .fill(purchaseColor.color)
                    .frame(width: 40, height: 40)
            }
            .frame(width: 48, height: 48)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var selectedColor: PurchaseColor?
    
    ColorSelectorView(selectedColor: $selectedColor)
        .padding(.vertical)
        .frame(maxHeight: .infinity, alignment: .center)
        .background(.primaryBackground)
}
