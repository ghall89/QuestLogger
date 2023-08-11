import SwiftUI

struct StatusMenuView: View {
	@AppStorage("customCollections") var customCollections: [Folder] = []
	@EnvironmentObject var observableCollection: ObservableCollection

	@Binding var game: Game
	@Binding var showingAlert: Bool
	let dismissSheet: (() -> Void)?

	private func addToFolder(selectedFolder: Folder) {
		if let index = customCollections.firstIndex(where: { $0.id == selectedFolder.id }) {
			customCollections[index].games.append(game.id)
		}
	}

	private func removeFromFolder(selectedFolder: Folder) {
		if let index = customCollections.firstIndex(where: { $0.id == selectedFolder.id }) {
			customCollections[index].games.removeAll(where: {$0 == game.id})
		}
	}

	var body: some View {

		VStack {
			if game.in_collection == true && customCollections.count >= 1 {
				Menu(content: {
					ForEach(customCollections) { folder in
						Button(action: {
								addToFolder(selectedFolder: folder)
						}, label: {
							Text(folder.name)
						})
						.disabled(folder.games.contains(game.id))
					}
				}, label: {
					Text(LocalizedStringKey("add_to_folder"))
				})
				Divider()
			}

			if game.status != Game.Status(rawValue: "wishlist") {
				Button(action: {
					addOrUpdateGame(game: game, collection: &observableCollection.collection, status: "wishlist")
				}, label: {
					Text(LocalizedStringKey("wishlist"))
				})
			}

			if game.status != Game.Status(rawValue: "backlog") {
				Button(action: {
					addOrUpdateGame(game: game, collection: &observableCollection.collection, status: "backlog")
				}, label: {
					Text(LocalizedStringKey("backlog"))
				})
			}

			if game.status != Game.Status(rawValue: "now_playing") {
				Button(action: {
					addOrUpdateGame(game: game, collection: &observableCollection.collection, status: "now_playing")
				}, label: {
					Text(LocalizedStringKey("now_playing"))
				})
			}

			if game.status != Game.Status(rawValue: "finished") {
				Button(action: {
					addOrUpdateGame(game: game, collection: &observableCollection.collection, status: "finished")
				}, label: {
					Text(LocalizedStringKey("finished"))
				})
			}
			Divider()

			if game.in_collection == true && game.status != Game.Status(rawValue: "archived") && game.status != Game.Status(rawValue: "wishlist") {
				Button(action: {
					addOrUpdateGame(game: game, collection: &observableCollection.collection, status: "archived")
				}, label: {
					Text(LocalizedStringKey("archive"))
				})
			}

			if game.in_collection == true {
				Button(role: .destructive, action: {
					showingAlert.toggle()
				}, label: {
					Text(LocalizedStringKey("delete"))
				})
			}
		}
	}
}
