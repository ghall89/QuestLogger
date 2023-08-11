import Foundation
import SwiftUI
import Alamofire

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
