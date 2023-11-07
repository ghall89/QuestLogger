import Foundation
import SwiftUI

public enum Status: CaseIterable, Codable {
	case wishlist
	case backlog
	case nowPlaying
	case finished
	case paused
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
			case "paused":
				self = .paused
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
			case .paused:
				return "paused"
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
				return "trophy.fill"
			case .paused:
				return "pause.fill"
			case .archived:
				return "archivebox.fill"
		}
	}
}
