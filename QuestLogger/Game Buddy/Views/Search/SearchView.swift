import SwiftUI
import QuestKit

struct SearchView: View {
	@Environment(\.dismiss) var dismiss
	
	@Binding var searchString: String

	@State var gameList: Array = [Game]()
	@FocusState private var searchFieldFocused: Bool
	@State private var searchTimer: Timer?
	@State private var loading: Bool = false

	@State private var showConnectionAlert: Bool = false

	func searchAction() {
		getSearchResults(searchString: searchString) { response in
			gameList.removeAll()
			gameList.append(contentsOf: response)
			loading = false
		}
	}

	func selectCategoryAction(category: String) {
		getByCategory(category: category) { response in
			gameList.removeAll()
			gameList.append(contentsOf: response)
			loading = false
		}
	}

	var body: some View {
		ScrollViewReader { _ in
			ScrollView {
				if loading {
					ProgressView()
						.offset(y: 10)
				} else if searchFieldFocused || gameList.count >= 1 {
					LazyVGrid(columns: [
						GridItem(.adaptive(minimum: 120), spacing: 24, alignment: .top),
					]) {
						ForEach($gameList) { game in
//							ResultView(game: game)
						}
					}.padding()
				} else {
					Text("No Results ☹️")
//					CategoryView(category: "new_releases")
//					CategoryView(category: "coming_soon")
//					CategoryView(category: "popular")
				}
			}
		}
		.navigationTitle("Search")
		.onChange(of: searchString) { _ in
			loading = true
			searchTimer?.invalidate()
			searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
				searchAction()
			}
		}
		.alert(LocalizedStringKey("noInternetTitle"), isPresented: $showConnectionAlert, actions: {
			Button("Ok", action: {
				self.dismiss()
			})
		}, message: {
			Text(LocalizedStringKey("noInternetMessage"))
		})
//		.onAppear() {
//			let isConnected = checkConnectivity()
//			if isConnected == false {
//				showConnectionAlert = true
//			}
//		}
	}
}
