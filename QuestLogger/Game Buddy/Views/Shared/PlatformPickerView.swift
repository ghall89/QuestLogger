import SwiftUI
import QuestKit

struct PlatformPickerView: View {
	@Binding var selectedPlatform: String
	var game: Game
	var gameDetails: GameDetails?
	
	var body: some View {
		Picker("Platform", selection: $selectedPlatform, content: {
			if gameDetails != nil {
				ForEach(gameDetails?.platforms ?? []) { platform in
					Text(platform.abbreviation ?? platform.name).tag(platform.abbreviation ?? platform.name)
				}
			} else if game.platform != nil {
				Text(game.platform!).tag(game.platform!)
			}
		})
	}
}
