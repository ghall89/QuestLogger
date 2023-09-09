import Foundation
import QuestKit

let sortComparisons: [String: (Game, Game) -> Bool] = [
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

func handleSorting(games: [Game], sorting: String) -> [Game] {
	func sortGames(val1: Game, val2: Game) -> Bool {
		guard let comparison = sortComparisons[sorting] else {
			return false
		}
		return comparison(val1, val2)
	}
	
	return games.sorted(by: sortGames)
}
