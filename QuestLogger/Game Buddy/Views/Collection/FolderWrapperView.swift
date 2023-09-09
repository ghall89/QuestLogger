import SwiftUI
import QuestKit

struct FolderWrapperView: View {
	@EnvironmentObject var observableCollection: CollectionViewModel
	
	@Binding var category: String
	
	@State var filteredGames = [Game]()
	
	var body: some View {
		FolderView(games: $filteredGames, category: category )
		.onAppear(perform: setFilteredGames)
		.onChange(of: category, perform: { _ in
			setFilteredGames()
		})
		.onChange(of: observableCollection.collection, perform: { _ in
			setFilteredGames()
		})
	}
	
	private func isValidCategory(string: String) -> Bool {
		let allCategories: [Status] = Status.allCases
		
		return allCategories.contains { category in
			string == category.status
		}
	}
	
	private func setFilteredGames() {
		if let validStatus = Status(statusString: category) {
			filteredGames = observableCollection.collection.filter {$0.status == validStatus}
		} else {
			filteredGames = observableCollection.collection.filter {$0.platform == category}
		}
	}
}
