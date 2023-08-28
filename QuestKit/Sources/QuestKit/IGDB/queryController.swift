import Foundation
import SwiftUI
import Alamofire

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

func queryController(params: String, completion: @escaping (Result<Data, Error>) -> Void) {
	@AppStorage("twitchClientID") var clientID: String = ""
	
	if let url = URL(string: "https://api.igdb.com/v4/games") {
		getIGDBToken { result in
			switch result {
				case .success(let token):
					let headers: [String: String] = [
						"Client-ID": clientID,
						"Authorization": "Bearer \(token)"
					]

					var request = URLRequest(url: url)
					request.httpMethod = HTTPMethod.post.rawValue
					request.allHTTPHeaderFields = headers
					request.httpBody = params.data(using: .utf8)
					request.cachePolicy = .returnCacheDataElseLoad
					AF.request(request)
						.validate()
						.responseData { response in
							switch response.result {
								case .success(let data):
									completion(.success(data))
								case .failure(let error):
									completion(.failure(error))
							}
						}
				case .failure(let error):
					print("Error: \(error)")
			}
		}
	} else {
		completion(.failure(NSError(domain: "Unknown Error", code: 0, userInfo: nil)))
	}
}
