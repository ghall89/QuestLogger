import SwiftUI
import QuestKit

struct FolderView: View {
	@EnvironmentObject var observableCollection: CollectionViewModel
	@EnvironmentObject var observableGameDetails: SelectedGameViewModel
	
	@State var games: [Game] = []
	@Binding var category: String
	@Binding var searchString: String
	
	@AppStorage("selectedViewSort") var selectedViewSort: String = "alphabetical"
	
	var body: some View {
		VStack(spacing: 0) {
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
					Text(LocalizedStringKey("alphabetical")).tag("alphabetical")
					Text(LocalizedStringKey("reverse_alphabetical")).tag("reverse_alphabetical")
					Divider()
					Text(LocalizedStringKey("oldest_first")).tag("oldest_first")
					Text(LocalizedStringKey("latest_first")).tag("latest_first")
				})
				.frame(width: 200)
				.padding()
			}
			.background(content: {
				Rectangle()
					.fill(.thickMaterial)
			})
			ScrollView {
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
		}
		.navigationTitle(LocalizedStringKey(category))
		.onAppear(perform: {
			handleFilter()
		})
		.onChange(of: category, perform: { _ in
			handleFilter()
		})
		.onChange(of: observableCollection.collection, perform: { _ in
			handleFilter()
		})
//		.onChange(of: searchString, perform: {
//			handleFilter()
//		})
	}
	
	private func handleFilter() {
		if searchString.isEmpty {
			setFilteredGames(
				collection: observableCollection.collection,
				filter: category,
				games: &games
			)
		} else {
			games = observableCollection.collection.filter { $0.name.lowercased().contains(searchString.lowercased()) }
		}
	}
}

