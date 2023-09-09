import Foundation
import QuestKit

class SelectedGameViewModel: ObservableObject {
	@Published var selectedGame: Game?
	@Published var detailSliderOpen: Bool = false
}
