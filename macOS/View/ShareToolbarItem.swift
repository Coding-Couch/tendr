//
//  ShareToolbarItem.swift
//  Tendr (macOS)
//
//  Created by Brent Mifsud on 2021-03-01.
//

import AppKit
import SwiftUI

struct ShareMenu: View {
	var sharedItems: [Any]
	var showText: Bool = false
	
	private var canCopyToPasteboard: Bool {
		var canCopy = false
		
		for item in sharedItems {
			if item as? NSPasteboardWriting != nil {
				canCopy = true
				break
			}
		}
		
		return canCopy
	}
	
	var body: some View {
		Menu {
			if canCopyToPasteboard {
				Button {
					let pasteboardItems = sharedItems.compactMap { any in
						any as? NSPasteboardWriting
					}
					
					let pasteboard = NSPasteboard.general
					pasteboard.clearContents()
					pasteboard.writeObjects(pasteboardItems)
				} label: {
					Image(systemName: "doc.on.doc")
					Text("Copy to Clipboard")
				}
			}
			
			ForEach(NSSharingService.sharingServices(forItems: sharedItems), id: \.title) { (service: NSSharingService) in
				Button {
					service.perform(withItems: sharedItems)
				} label: {
					Image(nsImage: service.image)
					Text(service.menuItemTitle)
				}
			}
		} label: {
			Image(systemName: "square.and.arrow.up")
			
			if showText {
				Text("Share")
			}
		}
	}
}
