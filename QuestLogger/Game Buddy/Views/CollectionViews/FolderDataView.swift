import SwiftUI

struct FolderDataView: View {
	@EnvironmentObject var observableCollection: ObservableCollection
	
	@Binding var category: String
	var folderId: UUID?
	
	@State var filteredGames = [Game]()
	
	private func isValidCategory(string: String) -> Bool {
		let allCategories: [Category] = [.wishlist, .backlog, .nowPlaying, .finished, .archived]
		
		return allCategories.contains { category in
			string == category.status
		}
	}
	
	private func setFilteredGames() {
		if isValidCategory(string: category) {
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
		FolderView(games: $filteredGames, category: getTitle() )
		.onAppear(perform: setFilteredGames)
		.onChange(of: category, perform: { _ in
			setFilteredGames()
		})
		.onChange(of: observableCollection.collection, perform: { _ in
			setFilteredGames()
		})
	}
}