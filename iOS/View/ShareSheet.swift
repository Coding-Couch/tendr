//
//  ShareSheet.swift
//
//
//  Created by Brent Mifsud on 2020-12-17.
//

import SwiftUI
import UIKit

/// View Modifier for presenting a share sheet.
public struct ShareSheetViewModifier: ViewModifier {
    @Binding public var isPresented: Bool
    public var sharedItems: [Any]
    public var activities: [UIActivity]?

    /// Attach a share sheet to the specified view
    /// - Parameters:
    ///   - isPresented: controls if the share sheet is showing or not
    ///   - sharedItems: items to share
    ///   - activities: `UIActivity` items to include in the share sheet
    public init(isPresented: Binding<Bool>, sharedItems: [Any], activities: [UIActivity]? = nil) {
        _isPresented = isPresented
        self.sharedItems = sharedItems
        self.activities = activities
    }

    public func body(content: Content) -> some View {
        content.overlay(
            ShareSheetView(isPresented: $isPresented, sharedItems: sharedItems, activities: activities)
                .ignoresSafeArea()
        )
    }
}

public extension View {
    /// Attach a share sheet to the specified view
    /// - Parameters:
    ///   - isPresented: determines whether to show the share sheet or not
    ///   - sharedItems: items to share
    ///   - activities: `UIActivity` items to include in the share sheet
    /// - Returns: some View
    func shareSheet(
        isPresented: Binding<Bool>,
        sharedItems: [Any],
        activities: [UIActivity]? = nil
    ) -> some View {
        modifier(
            ShareSheetViewModifier(
                isPresented: isPresented,
                sharedItems: sharedItems,
                activities: activities
            )
        )
    }
}

/// SwiftUI Implementation of a share sheet. Will likely be deprecated very soon.
struct ShareSheetView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ShareSheetHost

    class ShareSheetHost: UIViewController {
        @Binding var isPresented: Bool

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .clear
        }

        var isPresentingShareSheet: Bool {
            presentedViewController as? UIActivityViewController != nil
        }

        init(isPresented: Binding<Bool>) {
            self._isPresented = isPresented
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func presentShareSheet(sharedItems: [Any], activities: [UIActivity]?) {
            let controller = UIActivityViewController(
                activityItems: sharedItems,
                applicationActivities: activities
            )

            controller.completionWithItemsHandler = { _, _, _, _ in
                self.isPresented = false
            }

            present(controller, animated: true)
        }

        func dismissShareSheet() {
            self.presentedViewController?.dismiss(animated: true)
        }
    }

    @Binding var isPresented: Bool
    var sharedItems: [Any]
    var activities: [UIActivity]?

    func makeUIViewController(context _: Context) -> UIViewControllerType {
        let viewController = ShareSheetHost(isPresented: $isPresented)
        viewController.view.backgroundColor = .clear
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context _: Context) {
        if isPresented && !uiViewController.isPresentingShareSheet {
            uiViewController.presentShareSheet(sharedItems: sharedItems, activities: activities)
        }
    }
}

struct ShareSheet_Previews: PreviewProvider {
    @State static var showing: Bool = true

    static var previews: some View {
        Text("Hello World")
            .shareSheet(isPresented: $showing, sharedItems: ["Test"])
    }
}
