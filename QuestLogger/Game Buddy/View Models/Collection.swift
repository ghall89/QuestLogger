import Foundation
import SwiftUI
import QuestKit

class CollectionViewModel: ObservableObject, Equatable {
	@AppStorage("customDirectoryURL") var customDirectoryURL: URL = URL(string: "~/Documents")!
	
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
		var fileURL = customDirectoryURL
		fileURL.append(path: "Library.quest/game_collection.json")
		print(fileURL)
		do {
			let jsonData = try Data(contentsOf: fileURL)
			loadedCollection = decodeJSON(json: jsonData, model: Game.self)
			collection = loadedCollection
		} catch {
			print(error.localizedDescription)
		}
	}
	
	private func updatePlatforms() {
		platforms = Array(Set(collection.compactMap { $0.platform })).sorted()
	}
}
