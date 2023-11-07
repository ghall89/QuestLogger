import Foundation

public func getByCategory(category: String, completionHandler: @escaping (_ gameList: [Game]) -> Void) {
	
	let currentDate = Date()
	let currentTimestamp = Int(currentDate.timeIntervalSince1970)
	var categoryFilter: String
	
	switch category {
		case "new_releases":
			categoryFilter = "first_release_date < \(currentTimestamp) & first_release_date > \((currentTimestamp - 2419200)) & total_rating != null;sort total_rating desc"
		case "coming_soon":
			categoryFilter = "first_release_date > \(currentTimestamp)& hypes != null;sort hypes desc"
		case "popular":
			categoryFilter = "follows != null;sort follows desc"
		default:
			return
	}
	
	let bodyString = "limit \(igdbGameLimit);fields \(igdbGameSummaryFields);\(igdbGameWhere.joined(separator: " & ")) & \(categoryFilter);"
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
