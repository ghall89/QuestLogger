import Foundation

public struct GameDetails: Codable {
	public let id: Int
	public let cover: Img
	public let name: String
	public let screenshots: [Img]
	public let platforms: [Platform]
	public let first_release_date: Date?
	public let summary: String?
	public let genres: [Genre]
	public let similar_games: [Int]

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
	public let name: String
	enum CodingKeys: String, CodingKey {
		case id
		case name
	}
}

public struct Platform: Codable, Identifiable {
	public let id: Int
	public let abbreviation: String?
	public let name: String
	enum CodingKeys: String, CodingKey {
		case id
		case abbreviation
		case name
	}
}
