import Foundation
import QuestKit

class GlobalState: ObservableObject {
	@Published var selectedGame: Game?
	@Published var showAddGameSheet: Bool = false
	@Published var searchString: String = ""
}
