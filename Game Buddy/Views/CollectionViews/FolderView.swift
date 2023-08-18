import SwiftUI

struct FolderView: View {
	@EnvironmentObject var observableCollection: ObservableCollection
	@EnvironmentObject var observableGameDetails: ObservableGameDetails
	
	@Binding var games: [Game]
	let category: String
	
	@State private var selectedView: String = "grid"
	@State private var showViewSortOptions: Bool = false
	
	@AppStorage("selectedViewSort") var selectedViewSort: String = "alphabetical"
	
	init(games: Binding<[Game]>, category: String) {
		self._games = games
		self.category = category
		self._selectedViewSort = AppStorage(wrappedValue: "alphabetical", "selectedViewSort" + category)
	}
	
	private let sortComparisons: [String: (Game, Game) -> Bool] = [
		"alphabetical": { $0.name.lowercased() < $1.name.lowercased() },
		"reverse_alphabetical": { $0.name.lowercased() > $1.name.lowercased() },
		"latest_first": { val1, val2 in
			guard let date1 = val1.status_date, let date2 = val2.status_date else {
				return false
			}
			return date1 > date2
		},
		"oldest_first": { val1, val2 in
			guard let date1 = val1.status_date, let date2 = val2.status_date else {
				return false
			}
			return date1 < date2
		}
	]
	
	private func viewSort(val1: Game, val2: Game) -> Bool {
		guard let comparison = sortComparisons[selectedViewSort] else {
			return false
		}
		return comparison(val1, val2)
	}
	
	private func getRandomGame() {
		
		if games.isEmpty {
			return
		}
		
		if let randomGame = games.randomElement() {
			observableGameDetails.selectedGame = randomGame
			observableGameDetails.detailSliderOpen.toggle()
		} else {
			print("No games exist with these conditions")
		}
	}
	
	var body: some View {
		ZStack(alignment: .top) {
			ScrollView {
				Spacer(minLength: 50)
				LazyVGrid(columns: [
					GridItem(.adaptive(minimum: 120), spacing: 24, alignment: .top),
				]) {
					ForEach(games.sorted(by: viewSort), id: \.self.id) { game in
						if let gameIndex = observableCollection.collection.firstIndex(where: { $0.id == game.id }) {
							GameCoverView(game: $observableCollection.collection[gameIndex])
								.id(game.id)
						}
					}
				}
				.padding()
			}
			HStack {
				Button(action: {
					getRandomGame()
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
				Picker(selection: $selectedView, content: {
					Image(systemName: "rectangle.grid.3x2").tag("grid")
					Image(systemName: "list.bullet").tag("list")
					
				}, label: {})
				.pickerStyle(.segmented)
				.padding()
				.frame(width: 120)
			}
			.background(content: {
				Rectangle()
					.fill(.thickMaterial)
			})
		}
		.navigationTitle(category)
	}
}

