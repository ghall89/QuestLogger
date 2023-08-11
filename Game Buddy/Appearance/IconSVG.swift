import Foundation
import SwiftUI

enum IconSize {
	case small
	case medium
	case large
}

struct IconSVG: View {
	let icon: String
	let size: IconSize?

	init(icon: String, size: IconSize? = .medium) {
		self.icon = icon
		self.size = size
	}

	func sizeVal() -> CGFloat {
		if let size = size {
			switch size {
				case .small:
					return 20
				case .medium:
					return 26
				case .large:
					return 30
			}
		}
		return 23
	}

	var body: some View {
		Image(icon)
			.resizable()
			.renderingMode(.template)
			.frame(width: sizeVal(), height: sizeVal())
	}
}
