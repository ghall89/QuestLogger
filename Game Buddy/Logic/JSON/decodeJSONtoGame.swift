import Foundation

func decodeJSONtoGame(json: Data) -> [Game] {
	let decoder = JSONDecoder()
	do {
		let games = try decoder.decode([Game].self, from: json)
		return games
	} catch let error as NSError {
		print("Error decoding JSON: \(error.localizedDescription)")
	} catch {
		print("Unknown error decoding JSON")
	}
	return []
}
