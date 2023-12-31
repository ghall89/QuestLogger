import Foundation

public func getSearchResults(searchString: String, completionHandler: @escaping (_ gameList: [Game]) -> Void) {
	
	let bodyString = "search \"\(searchString)\";limit \(igdbGameLimit);fields \(igdbGameSummaryFields);\(igdbGameWhere.joined(separator: " & "));"
	print(bodyString)
	queryController(params: bodyString) {result in
		switch result {
			case .success(let data):
				let response = decodeJSON(json: data, model: Game.self)
				completionHandler(response)
			case .failure(let error):
				print(error)
		}
	}
}
