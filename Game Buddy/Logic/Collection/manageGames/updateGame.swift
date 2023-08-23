import Foundation

func updateGame(id: Int, collection: inout [Game], status: String? = nil, platform: String? = nil, note: String? = nil) {
	if let index = collection.firstIndex(where: { $0.id == id }) {
		if status != nil {
			collection[index].status = Game.Status(rawValue: status!)
			collection[index].status_date = Date()
		}
		if platform != nil {
			collection[index].platform = platform
		}
		if note != nil {
			collection[index].notes = note
		}
		storeCollectionAsJSON(collection: collection)
	}
}
