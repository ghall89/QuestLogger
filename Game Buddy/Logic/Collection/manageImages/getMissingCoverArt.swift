import Foundation

func getMissingCovertArt(collection: [Game]) {
	let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	collection.forEach { game in
		let imageId = game.cover.image_id
		let fileURL = documentsDirectory.appendingPathComponent("covers/\(imageId).png")
		if !FileManager.default.fileExists(atPath: fileURL.path) {
			downloadImage(imageId: imageId)
		}
	}
}
