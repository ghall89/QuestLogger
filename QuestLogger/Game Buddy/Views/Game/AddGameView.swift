import SwiftUI
import QuestKit

struct AddGameView: View {
	@EnvironmentObject var observableCollection: CollectionViewModel
	@Binding var showAddGame: Bool
	@Binding var showConfirmation: Bool
	var game: Game
	
	@State private var selectedStatus: Status = .backlog
	@State var gameDetails: GameDetails?
	@State var selectedPlatform: String = ""
	
	var body: some View {
		VStack(spacing: 20) {
			Picker("Status", selection: $selectedStatus, content: {
				ForEach(Status.allCases, id: \.self.status, content: {category in
					Text(LocalizedStringKey(category.status)).tag(category)
				})
			})
			PlatformPickerView(selectedPlatform: $selectedPlatform, game: game, gameDetails: gameDetails)
			HStack {
				Spacer()
				Button(action: {
					showAddGame.toggle()
					selectedStatus = .backlog
				}, label: {
					Text("Cancel")
				})
				Button(action: {
					addGame(game: game, collection: &observableCollection.collection, status: selectedStatus, platform: selectedPlatform)
					showAddGame.toggle()
					selectedStatus = .backlog
					showConfirmation.toggle()
				}, label: {
					Text("Add")
				})
				.keyboardShortcut(.defaultAction)
			}
		}
		.padding()
		.frame(width: 300)
		.onAppear {
			getGameById(id: game.id) {result in
				gameDetails = result
				selectedPlatform = result.platforms[0].abbreviation ?? result.platforms[0].name
			}
		}
	}
}
