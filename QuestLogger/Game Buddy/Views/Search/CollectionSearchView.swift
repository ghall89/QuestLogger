import SwiftUI
import Foundation

struct CollectionSearchView: View {
	@EnvironmentObject var observableCollection: CollectionViewModel

	@Binding var searchValue: String

	let options: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]

	var body: some View {
		LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 10) {
			ForEach(observableCollection.collection
				.filter { ($0.name.range(of: searchValue, options: options) != nil) }
			) { game in GameCoverView(game: $observableCollection.collection[observableCollection.collection.firstIndex(of: game)!]) .id(game.id) }
		}
		.padding()
	}
}
