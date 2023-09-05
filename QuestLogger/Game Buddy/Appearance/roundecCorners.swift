import SwiftUI

struct ImgMaskRect: Shape {
	func path(in rect: CGRect) -> Path {
		let width = rect.width
		let cornerSize = width / 8
		
		let corners = CGSize(width: cornerSize, height: cornerSize)
		
		var path = Path()
		path.addRoundedRect(in: rect, cornerSize: corners, style: .continuous)
		
		return path
	}
}
