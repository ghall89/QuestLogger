import SwiftUI
import QuestKit

struct StarRatingView: View {
	@EnvironmentObject var observableCollection: CollectionViewModel
	@Binding var game: Game
	@State private var hoverState: HoverState = HoverState(hover: false, value: 0)
	
	var body: some View {
		HStack {
			ForEach(1...5, id: \.self) { num in
				Image(systemName: starIsActive(value: num) ? "star.fill" : "star")
					.font(.system(size: 16))
					.foregroundColor(.yellow)
					.onTapGesture {
						updateGame(id: game.id, collection: &observableCollection.collection, rating: num == game.rating ? 0 : num)
					}
					.onHover(perform: { hovering in
						hoverState.hover.toggle()
						hoverState.value = num
					})
					.scaleEffect(hoverState.hover && hoverState.value == num ? 1.1 : 1)
			}
		}
		.padding()
	}
	
	private func starIsActive(value: Int) -> Bool {
		if hoverState.hover && hoverState.value >= value {
			return true
		}
		
		if game.rating ?? 0 >= value {
			return true
		}
		
		return false
	}
	
	private struct HoverState {
		var hover: Bool
		var value: Int
	}
}
