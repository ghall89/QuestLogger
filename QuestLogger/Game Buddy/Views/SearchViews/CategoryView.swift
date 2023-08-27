import SwiftUI
import SwiftfulLoadingIndicators
import QuestKit

struct CategoryItemView: View {
	var label: String
	var icon: String
	var color: Color

	var body: some View {
		RoundedRectangle(cornerRadius: 20, style: .continuous)
			.fill(color)
			.frame(maxWidth: .infinity, minHeight: 75)
			.overlay(alignment: .leading) {
				HStack {
					Image(systemName: "folder")
						.foregroundColor(.white)
					Spacer()
					Text(LocalizedStringKey(label))
						.fontWeight(.medium)
						.foregroundColor(.white)
				}.padding()
			}
	}
}

struct CategoryView: View {
	var category: String
	@State var gameList: Array = [Game]()
	@State private var loading: Bool = true

	func selectCategoryAction() {
		getByCategory(category: category) { response in
			gameList.append(contentsOf: response)
			loading = false
		}
	}

	var body: some View {
		VStack(alignment: .leading) {
			Text(LocalizedStringKey(category))
				.font(.title)
				.padding(.leading)
				.padding(.top)
			ScrollView(.horizontal) {
				if loading {
					HStack {
						LoadingIndicator(animation: .bar, color: .accentColor)
							.offset(y: 10)
					}
					.frame(maxWidth: .infinity)
				} else {
					LazyHGrid(rows: [GridItem()], alignment: .top) {
						ForEach($gameList) { game in
							ResultView(game: game)
								.frame(width: 180)
						}
					}
					.padding()
				}
			}
			.onAppear(perform: {
				selectCategoryAction()
			})
		}
	}
}
