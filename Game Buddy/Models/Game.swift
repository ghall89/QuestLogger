import Foundation

struct Game: Codable, Identifiable, Equatable {
	let id: Int
	let cover: Img
	let name: String
	let first_release_date: Date?
	var in_collection: Bool? = false
	var status: Status?
	var status_date: Date?
	var platform: Platform?
//	var folders: [Folder]?
	static func == (lhs: Game, rhs: Game) -> Bool {
		return lhs.id == rhs.id &&
		lhs.in_collection == rhs.in_collection &&
		lhs.status == rhs.status &&
		lhs.status_date == rhs.status_date
	}

	enum CodingKeys: String, CodingKey {
		case id
		case cover
		case name
		case first_release_date
		case in_collection
		case status
		case status_date
		case platform
//		case folders
	}

	enum Status: String, Codable {
		case wishlist
		case backlog
		case now_playing
		case finished
		case archived
	}
}
