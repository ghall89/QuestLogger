import Foundation
import QuestKit

func setFilteredGames(collection: [Game], filter: String, games: inout [Game]) {
	if let validStatus = Status(statusString: filter) {
		games = collection.filter {$0.status == validStatus}
	} else {
		games = collection.filter {$0.platform == filter}
	}
}
