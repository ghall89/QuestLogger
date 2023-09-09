import Foundation
import QuestKit

func getRandomGame(games: [Game], selectedGame: SelectedGameViewModel) {
	
	if games.isEmpty {
		return
	}
	
	if let randomGame = games.randomElement() {
		selectedGame.selectedGame = randomGame
		selectedGame.detailSliderOpen.toggle()
	} else {
		print("No games exist with these conditions")
	}
}
