import Foundation


class ObservableCollection: ObservableObject, Equatable {
	static func == (lhs: ObservableCollection, rhs: ObservableCollection) -> Bool {
		return lhs.collection == rhs.collection
	}
	@Published var collection = [Game]() {
		didSet {
			updatePlatforms()
		}
	}
	@Published var platforms = [String]()
	
	init() {
		loadCollectionFromJSON()
		updatePlatforms()
	}
	func loadCollectionFromJSON() {
		var loadedCollection = [Game]()
		let fileManager = FileManager.default
		if let fileURL = try? fileManager
			.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
			.appendingPathComponent("game_collection.json") {
			do {
				let jsonData = try Data(contentsOf: fileURL)
				loadedCollection = decodeJSONtoGame(json: jsonData)
				collection = loadedCollection
			} catch {
				print(error.localizedDescription)
			}
		}
		collection = loadedCollection
	}
	
	private func updatePlatforms() {
		platforms = Array(Set(collection.compactMap { $0.platform })).sorted()
	}
}
