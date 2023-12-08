import Foundation
import SwiftUI

public func getMissingCovertArt(collection: [Game]) {
	@AppStorage("customDirectoryURL") var customDirectoryURL: URL = URL(string: "~/Documents")!

	collection.forEach { game in
		let imageId = game.cover.image_id
		var fileURL = customDirectoryURL
		fileURL.append(path: "Library.quest/img/\(imageId).png")
		if !FileManager.default.fileExists(atPath: fileURL.path) {
			downloadImage(imageId: imageId)
		}
	}
}
