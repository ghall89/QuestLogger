import Foundation

func decodeJSONtoGameDetails(json: Data) -> [GameDetails] {
	let decoder = JSONDecoder()
	do {
		let games = try decoder.decode([GameDetails].self, from: json)
		return games
	} catch let error as NSError {
		print("Error decoding JSON: \(error.localizedDescription)")
	} catch {
		print("Unknown error decoding JSON")
	}
	return []
}
