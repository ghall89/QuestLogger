import Foundation

public func updateGame(id: Int, collection: inout [Game], status: Status? = nil, platform: String? = nil, note: String? = nil, rating: Int? = nil) {
	if let index = collection.firstIndex(where: { $0.id == id }) {
		if status != nil {
			collection[index].status = status
			collection[index].status_date = Date()
		}
		if platform != nil {
			collection[index].platform = platform
		}
		if note != nil {
			collection[index].notes = note
		}
		if rating != nil {
			collection[index].rating = rating
		}
		storeCollectionAsJSON(collection: collection)
	}
}
