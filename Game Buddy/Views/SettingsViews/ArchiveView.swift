import SwiftUI

struct ArchiveView: View {
	@EnvironmentObject var observableCollection: ObservableCollection
	@EnvironmentObject var observableGameDetails: ObservableGameDetails

	var body: some View {
		List {
			ForEach(observableCollection.collection.sorted(by: { $0.name < $1.name })) {game in
				if game.status == Game.Status(rawValue: "archived") {
					Button(game.name, action: {
						observableGameDetails.selectedGame = game
						observableGameDetails.detailSliderOpen.toggle()
					}).swipeActions {
						Button(LocalizedStringKey("delete"), role: .destructive) {
							removeGame(id: game.id, collection: &observableCollection.collection)
						}
					}
				}
			}
		}
		.listStyle(PlainListStyle())
		.navigationTitle(LocalizedStringKey("view_archived"))
	}
}
