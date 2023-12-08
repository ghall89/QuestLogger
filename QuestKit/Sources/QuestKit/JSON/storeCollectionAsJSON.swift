import Foundation
import SwiftUI

public func storeCollectionAsJSON(collection: [Game]) {
	@AppStorage("customDirectoryURL") var customDirectoryURL: URL = URL(string: "~/Documents")!
	
	let encoder = JSONEncoder()
	do {
		let jsonData = try encoder.encode(collection)
		let fileManager = FileManager.default

		var fileURL = customDirectoryURL
		fileURL.append(path: "Library.quest/game_collection.json")
		try fileManager.createDirectory(
			at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
		fileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
		try jsonData.write(to: fileURL, options: .atomic)
	} catch {
		print(error.localizedDescription)
	}
}
