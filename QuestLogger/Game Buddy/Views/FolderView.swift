import SwiftUI
import QuestKit

struct FolderView: View {
	@EnvironmentObject var observableCollection: CollectionViewModel
	@EnvironmentObject var globalState: GlobalState
	
	@State var games: [Game] = []
	@Binding var category: String
	
	@AppStorage("selectedViewSort") var selectedViewSort: String = "alphabetical"
	
	var body: some View {
		VStack(spacing: 0) {
			HStack {
				Button(action: {
					getRandomGame(games: games, selectedGame: globalState)
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
							GameCoverView(game: $observableCollection.collection[gameIndex], captionString: getCaptionString(game: game))
								.id(game.id)
							
						}
					}
				}
				.padding()
			}
			.onTapGesture(perform: {
				globalState.selectedGame = nil
			})
		}
		.navigationTitle(LocalizedStringKey(category))
		.onAppear(perform: {
			handleFilter()
		})
		.onChange(of: FilterProperties(category: category, collection: observableCollection.collection, searchString: globalState.searchString)) { _ in
			handleFilter()
		}
	}
	
	private func handleFilter() {
		setFilteredGames(
			collection: observableCollection.collection,
			filter: category,
			games: &games,
			search: globalState.searchString
		)
	}
	
	private func getCaptionString(game: Game) -> String {
		if Status(statusString: category) != nil {
			return game.platform ?? ""
		} else {
			return NSLocalizedString(game.status?.status ?? "", comment: "")
		}
	}
	
	private struct FilterProperties: Equatable {
		var category: String
		var collection: [Game]
		var searchString: String
	}
}

