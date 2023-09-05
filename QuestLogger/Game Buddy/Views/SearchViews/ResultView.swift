import SwiftUI
import QuestKit

func swapInCollectionGame(inputGame: Game) -> Binding<Game> {
	let observableCollection = ObservableCollection()
	if let index = observableCollection.collection.firstIndex(where: { $0.id == inputGame.id }) {
		return Binding<Game>(
			get: { observableCollection.collection[index] },
			set: { observableCollection.collection[index] = $0 }
		)
	}
	return Binding<Game>(get: { inputGame }, set: { _ in })
}

struct ResultView: View {
	@Binding var game: Game

	var body: some View {
		let displayGame = swapInCollectionGame(inputGame: game)
		ZStack(alignment: .top) {
			GameCoverView(game: displayGame).id(displayGame.id)
			if displayGame.wrappedValue.in_collection == true {
				Image(systemName: "checkmark.circle.fill")
					.shadow(radius: 6)
					.foregroundColor(.green)
					.background(content: {
						Circle()
							.fill(.black)
							.frame(width: 20)
					})
					.position(x: 20, y: 20)
			}
		}
	}
}
