import Foundation

public func getMissingCovertArt(collection: [Game]) {
	let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	collection.forEach { game in
		let imageId = game.cover.image_id
		let fileURL = documentsDirectory.appendingPathComponent("Library.quest/img/\(imageId).png")
		if !FileManager.default.fileExists(atPath: fileURL.path) {
			downloadImage(imageId: imageId)
		}
	}
}
