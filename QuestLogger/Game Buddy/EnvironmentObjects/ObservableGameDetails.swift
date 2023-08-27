import Foundation
import QuestKit

class ObservableGameDetails: ObservableObject {
	@Published var selectedGame: Game?
	@Published var detailSliderOpen: Bool = false
}
