import Foundation

public struct GameDetails: Codable {
	let id: Int
	let cover: Img
	let name: String
	let screenshots: [Img]
	let platforms: [Platform]
	let first_release_date: Date?
	let summary: String?
	let genres: [Genre]
	let similar_games: [Int]

	enum CodingKeys: String, CodingKey {
		case id
		case cover
		case name
		case screenshots
		case platforms
		case first_release_date
		case summary
		case genres
		case similar_games
	}
}

public struct Genre: Codable, Identifiable {
	public let id: Int
	let name: String
	enum CodingKeys: String, CodingKey {
		case id
		case name
	}
}

public struct Platform: Codable, Identifiable {
	public let id: Int
	let abbreviation: String?
	let name: String
	enum CodingKeys: String, CodingKey {
		case id
		case abbreviation
		case name
	}
}
