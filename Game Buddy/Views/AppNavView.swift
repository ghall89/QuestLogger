import SwiftUI

struct AppNavView: View {
	@State private var navigationPath: [Int] = []
	@State private var isActive = false
	@EnvironmentObject var observableGameDetails: ObservableGameDetails
	@EnvironmentObject var observableCollection: ObservableCollection
	@AppStorage("colorTheme") var colorTheme: String = "blue"
	@AppStorage("fabPostion") var fabPosition: String = "right"

	private var selectedGameBinding: Binding<Game>? {
		guard let selectedGame = observableGameDetails.selectedGame else { return nil }
		if selectedGame.in_collection == true {
			return $observableCollection.collection.first(where: { $0.id == selectedGame.id })
		}
		if let gameIndex = observableCollection.collection.firstIndex(where: { $0.id == selectedGame.id }) {
			return $observableCollection.collection[gameIndex]
		}
		return Binding(get: { selectedGame }, set: { observableGameDetails.selectedGame = $0 })
	}

	var body: some View {
		NavigationView {
				CollectionView()
//			ZStack {
//				VStack {
//					Spacer()
//					HStack {
//						if fabPosition == "right" {
//							Spacer()
//						}
//						Circle()
//							.frame(width: 62)
//							.foregroundColor(.accentColor)
//							.overlay(content: {
//								IconSVG(icon: "plus-lg", size: .large)
//									.foregroundColor(.white)
//							})
//							.background(NavigationLink(
//								destination: SearchView(),
//								isActive: $isActive,
//								label: {
//								EmptyView()
//							}))
//							.padding()
//							.onTapGesture(perform: {
//								isActive.toggle()
//							})
//						if fabPosition == "left" {
//							Spacer()
//						}
//					}
//				}
//			}
		}
		.sheet(isPresented: $observableGameDetails.detailSliderOpen) {
			if let selectedGame = selectedGameBinding {
				GameDetailView(selectedGame: selectedGame).environmentObject(observableCollection)
					.userAccentColor(colorTheme)
			}
		}
	}
}
