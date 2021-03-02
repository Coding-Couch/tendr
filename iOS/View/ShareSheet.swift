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
		content.sheet(isPresented: $isPresented) {
			ShareSheetView(sharedItems: sharedItems, activities: activities)
				.edgesIgnoringSafeArea(.bottom)
		}
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
public struct ShareSheetView: UIViewControllerRepresentable {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	var sharedItems: [Any]
	var activities: [UIActivity]?

	/// Create a share sheet view
	/// - Parameters:
	///   - sharedItems: items to share
	///   - activities: `UIActivity` items to include in the share sheet
	public init(sharedItems: [Any], activities: [UIActivity]? = nil) {
		self.sharedItems = sharedItems
		self.activities = activities
	}

	public func makeUIViewController(context _: Context) -> UIActivityViewController {
		let controller = UIActivityViewController(
			activityItems: sharedItems,
			applicationActivities: activities
		)

		controller.completionWithItemsHandler = { _, _, _, _ in
			self.presentationMode.wrappedValue.dismiss()
		}

		return controller
	}

	public func updateUIViewController(_: UIActivityViewController, context _: Context) {}
}

struct ShareSheet_Previews: PreviewProvider {
	@State static var showing: Bool = true

	static var previews: some View {
		Text("Hello World")
			.shareSheet(isPresented: $showing, sharedItems: ["Test"])
	}
}
