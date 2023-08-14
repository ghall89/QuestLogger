import SwiftUI

struct FolderLinkView: View {
	@EnvironmentObject var observableCollection: ObservableCollection
	@AppStorage("customCollections") var customCollections: [Folder] = []

	var category: String
	var icon: String
	var folderId: UUID?

	@State var filteredGames = [Game]()
	
	private func isValidCategory(string: String) -> Bool {
		let allCategories: [Category] = [.wishlist, .backlog, .nowPlaying, .finished, .archived]
		
		return allCategories.contains { category in
			string == category.status
		}
	}

	private func setFilteredGames() {
		if folderId != nil {
			if let gameIds = customCollections.first(where: {$0.id == folderId})?.games {
				filteredGames = observableCollection.collection.filter {gameIds.contains($0.id)}
			}
		} else if isValidCategory(string: category) {
			filteredGames = observableCollection.collection.filter {$0.status == Game.Status(rawValue: category)}
		} else {
			filteredGames = observableCollection.collection.filter {$0.platform == category}
		}
	}

	private func getTitle() -> String {
		if folderId != nil {
			return category
		} else {
			let localizedKey = String.LocalizationValue(stringLiteral: category)
			return String(localized: localizedKey)
		}
	}

	var body: some View {
		NavigationLink(destination: FolderView(games: $filteredGames, category: getTitle() )) {
			HStack {
				Label(getTitle(), systemImage: icon)
				Spacer()
				Text(String(filteredGames.count))
			}
		}
		.onAppear(perform: {
			setFilteredGames()
		})
		.onChange(of: observableCollection.collection, perform: { _ in
			setFilteredGames()
		})
	}
}
