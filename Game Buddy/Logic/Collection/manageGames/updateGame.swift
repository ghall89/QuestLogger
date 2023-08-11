import Foundation

func updateGame(id: Int, collection: inout [Game], status: String) {
	if let index = collection.firstIndex(where: { $0.id == id }) {
		collection[index].status = Game.Status(rawValue: status)
		collection[index].status_date = Date()
		storeCollectionAsJSON(collection: collection)
	}
}

func updateGamePlatform(id: Int, collection: inout [Game], platform: String) {
	if let index = collection.firstIndex(where: { $0.id == id }) {
		collection[index].platform = platform
		storeCollectionAsJSON(collection: collection)
	}
}
