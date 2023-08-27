import SwiftUI

enum ShadowStyle {
	case tiny
	case normal
	var color: Color {
		switch self {
			case .tiny:
				return .black.opacity(0.4)
			case .normal:
				return .black.opacity(0.33)
		}
	}
	var radius: CGFloat {
		switch self {
			case .tiny:
				return 1
			case .normal:
				return 6
		}
	}
	var offset: CGFloat {
		switch self {
			case .tiny:
				return 0
			case .normal:
				return 1
		}
	}
}

extension View {
	func prettyShadow(_ style: ShadowStyle) -> some View {
		let shadowStyle = style
		return self.shadow(color: shadowStyle.color, radius: shadowStyle.radius, x: shadowStyle.offset, y: shadowStyle.offset)
	}
}
