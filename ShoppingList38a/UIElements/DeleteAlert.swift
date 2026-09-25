//
//  DeleteAlert.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 25.09.2026.
//

import SwiftUI
import UIKit

private struct DeleteAlertModifier: ViewModifier {
    let title: String
    let message: String
    
    @Binding var isPresented: Bool
    
    let onCancel: () -> Void
    let onDelete: () -> Void
    
    func body(content: Content) -> some View {
        content
            .background {
                DeleteAlertPresenter(
                    title: title,
                    message: message,
                    isPresented: $isPresented,
                    onCancel: onCancel,
                    onDelete: onDelete
                )
            }
    }
}

private struct DeleteAlertPresenter: UIViewControllerRepresentable {
    
    private enum DeleteAlertTexts {
        static let cancel = "Отменить"
        static let delete = "Удалить"
    }
    
    let title: String
    let message: String
    
    @Binding var isPresented: Bool
    
    let onCancel: () -> Void
    let onDelete: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            isPresented: $isPresented,
            onCancel: onCancel,
            onDelete: onDelete
        )
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: Context
    ) {
        context.coordinator.isPresented = $isPresented
        context.coordinator.onCancel = onCancel
        context.coordinator.onDelete = onDelete
        
        guard isPresented else {
            if let alert = uiViewController.presentedViewController as? UIAlertController {
                alert.dismiss(animated: true)
            }
            
            return
        }
        
        guard uiViewController.presentedViewController == nil else {
            return
        }
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: DeleteAlertTexts.cancel,
            style: .cancel
        ) { _ in
            context.coordinator.cancel()
        }
        
        let deleteAction = UIAlertAction(
            title: DeleteAlertTexts.delete,
            style: .destructive
        ) { _ in
            context.coordinator.delete()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        alert.preferredAction = deleteAction
        alert.view.tintColor = UIColor(Color.turquoise)
        
        uiViewController.present(
            alert,
            animated: true
        )
    }
}

private final class Coordinator {
    var isPresented: Binding<Bool>
    var onCancel: () -> Void
    var onDelete: () -> Void
    
    init(
        isPresented: Binding<Bool>,
        onCancel: @escaping () -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.isPresented = isPresented
        self.onCancel = onCancel
        self.onDelete = onDelete
    }
    
    func cancel() {
        isPresented.wrappedValue = false
        onCancel()
    }
    
    func delete() {
        isPresented.wrappedValue = false
        onDelete()
    }
}

extension View {
    func deleteAlert(
        title: String,
        message: String,
        isPresented: Binding<Bool>,
        onCancel: @escaping () -> Void = { },
        onDelete: @escaping () -> Void
    ) -> some View {
        modifier(
            DeleteAlertModifier(
                title: title,
                message: message,
                isPresented: isPresented,
                onCancel: onCancel,
                onDelete: onDelete
            )
        )
    }
}
