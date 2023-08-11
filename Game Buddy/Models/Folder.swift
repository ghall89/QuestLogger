import Foundation
import SwiftUI

struct Folder: Identifiable, Codable, Equatable {
	var id: UUID = UUID()
	var name: String
	var icon: String
	var color: String
	var games: [Int]
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case icon
		case color
		case games
	}
}
