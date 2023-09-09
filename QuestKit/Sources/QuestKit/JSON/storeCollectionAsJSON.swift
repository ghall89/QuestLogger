import Foundation

public func storeCollectionAsJSON(collection: [Game]) {
	let encoder = JSONEncoder()
	do {
		let jsonData = try encoder.encode(collection)
		let fileManager = FileManager.default
		let documentsDirectory = try fileManager.url(
			for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
		let fileURL = documentsDirectory.appendingPathComponent("Library.quest/game_collection.json")
		try fileManager.createDirectory(
			at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
		fileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
		try jsonData.write(to: fileURL, options: .atomic)
	} catch {
		print(error.localizedDescription)
	}
}
