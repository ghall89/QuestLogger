import Foundation
import SwiftUI

public enum Status: CaseIterable, Codable {
	case wishlist
	case backlog
	case nowPlaying
	case finished
	case archived
	
	public init?(statusString: String) {
		switch statusString {
			case "wishlist":
				self = .wishlist
			case "backlog":
				self = .backlog
			case "now_playing":
				self = .nowPlaying
			case "finished":
				self = .finished
			case "archived":
				self = .archived
			default:
				return nil
		}
	}

	public var status: String {
		switch self {
			case .wishlist:
				return "wishlist"
			case .backlog:
				return "backlog"
			case .nowPlaying:
				return "now_playing"
			case .finished:
				return "finished"
			case .archived:
				return "archived"
		}
	}

	public var icon: String {
		switch self {
			case .wishlist:
				return "wand.and.stars"
			case .backlog:
				return "list.bullet"
			case .nowPlaying:
				return "gamecontroller.fill"
			case .finished:
				return "checkmark"
			case .archived:
				return "archivebox.fill"
		}
	}
}
