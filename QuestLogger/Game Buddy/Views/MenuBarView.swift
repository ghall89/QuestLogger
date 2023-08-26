//
//  MenuBarView.swift
//  QuestLogger
//
//  Created by Graham Hall on 8/23/23.
//

import SwiftUI

struct MenuBarView: Commands {
	@StateObject var observableGameDetails = ObservableGameDetails()
	
	@Binding var showAboutView: Bool
	@Binding var selectedCategory: String
	
	var body: some Commands {
		CommandGroup(replacing: CommandGroupPlacement.appInfo) {
			Button("About QuestLogger") {
				showAboutView.toggle()
			}
		}
		CommandGroup(replacing: CommandGroupPlacement.newItem) {
			Button("Search", action: {
				
			})
			.keyboardShortcut(KeyboardShortcut(KeyEquivalent("F")))
		}
		CommandGroup(replacing: CommandGroupPlacement.sidebar, addition: {
			ForEach(Array(Category.allCases.enumerated()), id: \.element.status) { index, category in
				Button(LocalizedStringKey(category.status), action: {
					selectedCategory = category.status
				})
				.tag(index)
				.keyboardShortcut(KeyboardShortcut(KeyEquivalent(Character(String(index + 1)))))
			}
			Divider()
		})
		
		CommandMenu("Game", content: {
			Menu("Move to...", content: {
				ForEach(Category.allCases, id: \.self, content: { category in
					Button(LocalizedStringKey(category.status), action: {
						
					})
					.disabled(enableGameMenu())
					.keyboardShortcut(KeyEquivalent(category.status.first!), modifiers: [.option, .command])
				})
			})
			Divider()
			Button("Delete", action: {
				
			})
			.disabled(enableGameMenu())
			.keyboardShortcut(.delete)
		})

		CommandGroup(replacing: CommandGroupPlacement.help, addition: {
			Link("Report an Issue", destination: URL(string:"https://github.com/ghall89/questlogger-mac/issues")!)
		})
	}
	
	private func enableGameMenu() -> Bool {
		// check that a game is currently selected and stored in the observableGameDetails object
		if let inCollection = observableGameDetails.selectedGame?.in_collection {
			if inCollection {
				return false
			} else {
				return true
			}
		}
		return true
	}
}
