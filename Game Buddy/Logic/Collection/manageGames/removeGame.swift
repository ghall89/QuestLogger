import Foundation

func removeGame(id: Int, collection: inout [Game]) {
	if let index = collection.firstIndex(where: { $0.id == id }) {
		deleteImage(imageId: collection[index].cover.image_id)
		collection.remove(at: index)
		storeCollectionAsJSON(collection: collection)
	}
}
