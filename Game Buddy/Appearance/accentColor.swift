import SwiftUI

enum AccentColor: String, CaseIterable {
	case blue
	case green
	case orange
	case purple
	case mint
	case red
	case cyan
	case indigo
	case pink

	var color: Color {
		switch self {
			case .blue:
				return .blue
			case .green:
				return .green
			case .orange:
				return .orange
			case .purple:
				return .purple
			case .mint:
				return .mint
			case .red:
				return .red
			case .cyan:
				return .cyan
			case .indigo:
				return .indigo
			case .pink:
				return .pink
		}
	}

	static func fromString(_ string: String) -> AccentColor? {
		return AccentColor(rawValue: string.lowercased())
	}
}

extension View {
	func userAccentColor(_ accentColorString: String?) -> some View {
		if let accentColor = AccentColor(rawValue: accentColorString ?? "blue") {
			return self.accentColor(accentColor.color)
		} else {
			return self.accentColor(.blue)
		}
	}
}

extension View {
	func accentPickerColor(_ accentColorString: String?) -> some View {
		if let accentColor = AccentColor(rawValue: accentColorString ?? "blue") {
			return self.foregroundColor(accentColor.color)
		} else {
			return self.foregroundColor(.blue)
		}
	}
}
