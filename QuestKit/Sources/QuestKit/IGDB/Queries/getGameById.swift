import Foundation

public func getGameById(id: Int, completionHandler: @escaping (_ game: GameDetails) -> Void) {

	let bodyString = "where id = \(id);fields \(igdbGameSummaryFields),\(igdbGameDetailFields);"
	print(bodyString)

	queryController(params: bodyString) {result in
		switch result {
			case .success(let data):
				let response = decodeJSON(json: data, model: GameDetails.self)
				completionHandler(response[0])
			case .failure(let error):
				print(error)
		}
	}
}
