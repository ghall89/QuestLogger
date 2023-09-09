import Foundation
import QuestKit

func isValidStatus(string: String) -> Bool {
	let allCategories: [Status] = Status.allCases
	
	return allCategories.contains { category in
		string == category.status
	}
}
