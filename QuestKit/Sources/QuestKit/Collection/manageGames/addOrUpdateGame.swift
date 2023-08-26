import Foundation

public func addOrUpdateGame(game: Game, collection: inout [Game], status: String, platform: String? = nil) {

	if game.in_collection == true {
		updateGame(id: game.id, collection: &collection, status: status)
	} else {
		addGame(game: game, collection: &collection, status: status, platform: platform)
	}
}
