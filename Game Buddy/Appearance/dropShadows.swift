import Foundation
import SwiftUI

extension View {
	func prettyShadow() -> some View {
		return self.shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 0)
	}
}
