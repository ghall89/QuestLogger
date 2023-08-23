import Foundation

func addGame(game: Game, collection: inout [Game], status: String, platform: String? = nil) {
	var gameToAdd: Game = game
	gameToAdd.in_collection = true
	gameToAdd.status = Game.Status(rawValue: status)
	gameToAdd.platform = platform
	gameToAdd.status_date = Date()
	collection.append(gameToAdd)
	storeCollectionAsJSON(collection: collection)
	downloadImage(imageId: String(describing: game.cover.image_id))
}
