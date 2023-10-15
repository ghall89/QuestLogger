import Foundation
import QuestKit

func setFilteredGames(
	collection: [Game],
	filter: String,
	games: inout [Game],
	search: String
) {
	print(search)
	if !search.isEmpty {
		games = collection.filter { $0.name.lowercased().contains(search.lowercased()) }
	} else if let validStatus = Status(statusString: filter) {
		games = collection.filter {$0.status == validStatus}
	} else {
		games = collection.filter {$0.platform == filter && $0.status != .wishlist }
	}
}
