import SwiftUI
import QuestKit

struct FolderView: View {
	@EnvironmentObject var observableCollection: CollectionViewModel
	@EnvironmentObject var observableGameDetails: SelectedGameViewModel
	
	@Binding var games: [Game]
	let category: String
	
	@AppStorage("selectedViewSort") var selectedViewSort: String = "alphabetical"
	
	init(games: Binding<[Game]>, category: String) {
		self._games = games
		self.category = category
		self._selectedViewSort = AppStorage(wrappedValue: "alphabetical", "selectedViewSort" + category)
	}
	
	var body: some View {
		ZStack(alignment: .top) {
			ScrollView {
				Spacer(minLength: 50)
				LazyVGrid(columns: [
					GridItem(.adaptive(minimum: 120), spacing: 24, alignment: .top),
				]) {
					ForEach(handleSorting(games: games, sorting: selectedViewSort), id: \.self.id) { game in
						if let gameIndex = observableCollection.collection.firstIndex(where: { $0.id == game.id }) {
							GameCoverView(game: $observableCollection.collection[gameIndex])
								.id(game.id)
						}
					}
				}
				.padding()
			}
			.onTapGesture(perform: {
				observableGameDetails.selectedGame = nil
			})
			HStack {
				Button(action: {
					getRandomGame(games: games, selectedGame: observableGameDetails)
				}, label: {
					Image(systemName: "shuffle")
				})
				.disabled(games.isEmpty)
				.padding()
				Spacer()
				Picker("Sort", selection: $selectedViewSort, content: {
					Text("Alphabetical").tag("alphabetical")
					Text("Reverse Alphabetical").tag("reverse_alphabetical")
					Divider()
					Text("Newest First").tag("latest_first")
					Text("Oldest First").tag("Oldest_first")
				})
				.frame(width: 200)
				.padding()
			}
			.background(content: {
				Rectangle()
					.fill(.thickMaterial)
			})
		}
		.navigationTitle(LocalizedStringKey(category))
	}
}

