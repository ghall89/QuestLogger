import Foundation
import SwiftUI
import UniformTypeIdentifiers

public struct Game: Codable, Identifiable, Equatable, Transferable {	
	public let id: Int
	public var cover: Img
	public var name: String
	public var first_release_date: Date?
	public var in_collection: Bool? = false
	public var status: Status?
	public var status_date: Date?
	public var platform: String?
	public var tags: [String]?
	public var rating: Int?
	public var notes: String?
	
	public static func == (lhs: Game, rhs: Game) -> Bool {
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
		case tags
		case rating
		case notes
	}
	
	static public var transferRepresentation: some TransferRepresentation {
		CodableRepresentation(contentType: .draggedGame)
	}
}

public struct Img: Codable, Identifiable {
	public let id: Int
	public let image_id: String
	
	enum CodingKeys: String, CodingKey {
		case id
		case image_id
	}
}

extension UTType {
	static let draggedGame = UTType(exportedAs: "com.ghalldev.draggableGame")
}
