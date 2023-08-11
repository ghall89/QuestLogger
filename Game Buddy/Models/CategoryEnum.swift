import Foundation
import SwiftUI

enum Category {
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

//	var color: Color {
//		switch self {
//			case .wishlist:
//				return .blue
//			case .backlog:
//				return .red
//			case .nowPlaying:
//				return .green
//			case .finished:
//				return .orange
//		}
//	}

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
