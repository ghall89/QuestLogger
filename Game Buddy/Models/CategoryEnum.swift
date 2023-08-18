import Foundation
import SwiftUI

enum Category: CaseIterable {
	case wishlist
	case backlog
	case nowPlaying
	case finished
	case archived

	var status: String {
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

	var icon: String {
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
