import Foundation
import QuestKit

func getRandomGame(games: [Game], selectedGame: GlobalState) {
	
	if games.isEmpty {
		return
	}
	
	if let randomGame = games.randomElement() {
		selectedGame.selectedGame = randomGame
	} else {
		print("No games exist with these conditions")
	}
}
