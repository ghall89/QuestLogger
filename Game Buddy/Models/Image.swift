import Foundation

struct Img: Codable, Identifiable {
	let id: Int
	let image_id: String

	enum CodingKeys: String, CodingKey {
		case id
		case image_id
	}
}
