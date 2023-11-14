import SwiftUI
import QuestKit
import ReleaseNotificationKit

struct MenuBar: Commands {
	@AppStorage("showArchive") var showArchive: Bool = true
	@StateObject var globalState = GlobalState()
	@EnvironmentObject var observableCollection: CollectionViewModel
	@Environment(\.isSearching) private var isSearching
	
	@Binding var showAboutView: Bool
	@Binding var selectedCategory: String
	@Binding var showAddGameSheet: Bool
	
	var body: some Commands {
		CommandGroup(replacing: CommandGroupPlacement.appInfo) {
			Button("About QuestLogger") {
				showAboutView.toggle()
			}
		}
		CommandGroup(replacing: CommandGroupPlacement.newItem) {
			Button("Add Game", action: {
				showAddGameSheet = true
			})
			.keyboardShortcut(KeyboardShortcut(KeyEquivalent("N")))
			Button("Search", action: {
				if let toolbar = NSApp.keyWindow?.toolbar,
					 let search = toolbar.items.first(where: { $0.itemIdentifier.rawValue == "com.apple.SwiftUI.search" }) as? NSSearchToolbarItem {
					search.beginSearchInteraction()
				}
			})
			.keyboardShortcut(KeyboardShortcut(KeyEquivalent("F")))
		}
		CommandGroup(replacing: CommandGroupPlacement.sidebar, addition: {
			ForEach(Array(Status.allCases.enumerated()), id: \.element.status) { index, category in
				Button(LocalizedStringKey(category.status), action: {
					selectedCategory = category.status
				})
				.tag(index)
				.keyboardShortcut(KeyboardShortcut(KeyEquivalent(Character(String(index + 1)))))
				.disabled(category == .archived && showArchive == false)
			}
			Divider()
		})

		CommandGroup(replacing: CommandGroupPlacement.help, addition: {
			Link("Report an Issue", destination: URL(string:"https://github.com/ghall89/questlogger-mac/issues")!)
			Link("Support on Ko-Fi", destination: URL(string:"https://ko-fi.com/ghalldev")!)
		})
	}
}
