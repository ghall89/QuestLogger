import Foundation

public func decodeJSON<T: Decodable>(json: Data, model: T.Type) -> [T] {
	let decoder = JSONDecoder()
	do {
		let games = try decoder.decode([T].self, from: json)
		return games
	} catch let error as NSError {
		print("Error decoding JSON: \(error.localizedDescription)")
	} catch {
		print("Unknown error decoding JSON")
	}
	return []
}
