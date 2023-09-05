import Foundation

public func gameExistsInCollection(gameId: Int) -> Bool {
	let observableCollection = ObservableCollection()

	if observableCollection.collection.contains(where: { $0.id == gameId }) {
		return true
	}

	return false
}
