import SwiftUI
import QuestKit

struct StatusMenu: View {
	@EnvironmentObject var observableCollection: CollectionViewModel

	@Binding var game: Game
	@Binding var showingAlert: Bool

	var body: some View {

		VStack {
			if game.status != Status.wishlist {
				Button(action: {
					addOrUpdateGame(game: game, collection: &observableCollection.collection, status: Status.wishlist)
				}, label: {
					Text(LocalizedStringKey("wishlist"))
				})
			}

			if game.status != Status.backlog {
				Button(action: {
					addOrUpdateGame(game: game, collection: &observableCollection.collection, status: Status.backlog)
				}, label: {
					Text(LocalizedStringKey("backlog"))
				})
			}

			if game.status != Status.nowPlaying {
				Button(action: {
					addOrUpdateGame(game: game, collection: &observableCollection.collection, status: Status.nowPlaying)
				}, label: {
					Text(LocalizedStringKey("now_playing"))
				})
			}

			if game.status != Status.finished {
				Button(action: {
					addOrUpdateGame(game: game, collection: &observableCollection.collection, status: Status.finished)
				}, label: {
					Text(LocalizedStringKey("finished"))
				})
			}
			Divider()

			if game.in_collection == true && game.status != Status.archived && game.status != Status.wishlist {
				Button(action: {
					addOrUpdateGame(game: game, collection: &observableCollection.collection, status: Status.archived)
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
