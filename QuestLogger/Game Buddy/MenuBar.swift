import SwiftUI
import QuestKit

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
		
		CommandMenu("Game", content: {
			Menu("Move to...", content: {
				ForEach(Status.allCases, id: \.self, content: { category in
					Button(LocalizedStringKey(category.status), action: {
						if let gameId = globalState.selectedGame?.id {
							updateGame(id: gameId, collection: &observableCollection.collection, status: category)
						}
					})
					.disabled(disableGameMenu())
					.keyboardShortcut(KeyEquivalent(category.status.first!), modifiers: [.option, .command])
				})
			})
			Divider()
			Button("Remove from Library", action: {
				if let gameId = globalState.selectedGame?.id {
					removeGame(id: gameId, collection: &observableCollection.collection)
				}
			})
			.disabled(disableGameMenu())
			.keyboardShortcut(.delete)
		})

		CommandGroup(replacing: CommandGroupPlacement.help, addition: {
			Link("Report an Issue", destination: URL(string:"https://github.com/ghall89/questlogger-mac/issues")!)
			Link("Support on Ko-Fi", destination: URL(string:"https://ko-fi.com/ghalldev")!)
		})
	}
	
	private func disableGameMenu() -> Bool {
		// check that a game is currently selected and stored in the globalState object
		if let inCollection = globalState.selectedGame?.in_collection {
			if inCollection == true {
				return false
			} else {
				return true
			}
		}
		return true
	}
}
