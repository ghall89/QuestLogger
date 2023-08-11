import Foundation

var igdbGameSummaryFields: String = "name,cover.image_id,screenshots.image_id,first_release_date"
var igdbGameDetailFields: String = "platforms.*,platforms.platform_logo.image_id,summary,genres.name,similar_games"
var igdbGameWhere: [String] = [
	"where cover != null",
	"screenshots != null",
	"first_release_date != null",
	"platforms != null",
	"platforms.abbreviation != null",
	"(category = 0 | category = 8 | category = 9 | category = 4 | category = 2)",
	"keywords != [24124,1617,1787,2004,1147,3384]"
]
var igdbGameLimit: Int = 24

func getSearchResults(searchString: String, completionHandler: @escaping (_ gameList: [Game]) -> Void) {

	let bodyString = "search \"\(searchString)\";limit \(igdbGameLimit);fields \(igdbGameSummaryFields);\(igdbGameWhere.joined(separator: " & "));"
	print(bodyString)
	queryController(params: bodyString) {result in
		switch result {
			case .success(let data):
				let response = decodeJSONtoGame(json: data)
				completionHandler(response)
			case .failure(let error):
				print(error)
		}
	}
}

func getByCategory(category: String, completionHandler: @escaping (_ gameList: [Game]) -> Void) {

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
				let response = decodeJSONtoGame(json: data)
				completionHandler(response)
			case .failure(let error):
				print(error)
		}
	}
}

func getGameById(id: Int, completionHandler: @escaping (_ game: GameDetails) -> Void) {

	let bodyString = "where id = \(id);fields \(igdbGameSummaryFields),\(igdbGameDetailFields);"
	print(bodyString)

	queryController(params: bodyString) {result in
		switch result {
			case .success(let data):
				let response = decodeJSONtoGameDetails(json: data)
				completionHandler(response[0])
			case .failure(let error):
				print(error)
		}
	}
}
