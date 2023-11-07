import Foundation
import QuestKit

class CollectionViewModel: ObservableObject, Equatable {
	static func == (lhs: CollectionViewModel, rhs: CollectionViewModel) -> Bool {
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
			.appendingPathComponent("Library.quest/game_collection.json") {
			do {
				let jsonData = try Data(contentsOf: fileURL)
				loadedCollection = decodeJSON(json: jsonData, model: Game.self)
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
