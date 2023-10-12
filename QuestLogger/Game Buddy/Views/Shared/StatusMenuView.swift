import SwiftUI
import QuestKit

struct StatusMenu: View {
	@EnvironmentObject var observableCollection: CollectionViewModel
	
	@Binding var game: Game
	@Binding var showingAlert: Bool
	
	var body: some View {
		Picker("", selection: $game.status) {
			ForEach(Status.allCases, id: \.self) { status in
				Button(action: {
					addOrUpdateGame(game: game, collection: &observableCollection.collection, status: status)
				}, label: {
					Text(LocalizedStringKey(status.status)).tag(game.status)
				})
			}
		}
		Divider()
		if game.in_collection == true {
			Button(role: .destructive, action: {
				showingAlert.toggle()
			}, label: {
				Text(LocalizedStringKey("delete"))
			})
		}
	}
}
