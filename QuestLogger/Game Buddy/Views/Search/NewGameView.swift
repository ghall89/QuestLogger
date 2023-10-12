import SwiftUI
import QuestKit
import CachedAsyncImage

struct NewGameView: View {
	@EnvironmentObject var observableCollection: CollectionViewModel
	
	@Binding var showSheet: Bool
	@State private var searchString: String = ""
	@State private var gameList: Array = [Game]()
	@State private var loading: Bool = false
	
	var body: some View {
		NavigationStack {
			HStack {
				TextField("Find Games...", text: $searchString)
					.textFieldStyle(.roundedBorder)
				Button("Search", action: {
					searchAction()
				})
				.keyboardShortcut(.defaultAction)
			}
			.padding()
			if gameList.isEmpty {
				VStack {
					if loading {
						ProgressView()
					} else {
						Image(systemName: "magnifyingglass.circle.fill")
							.font(.largeTitle)
						Text("Search for games...")
					}
				}
				.frame(maxHeight: .infinity)
			} else {
				List {
					ForEach(gameList) { game in
						NavigationLink(destination: {
							AddGameView(game: game, showSheet: $showSheet)
						}, label: {
							HStack {
								CachedAsyncImage(url: getImageURL(imageId: game.cover.image_id)) { image in
									image
										.resizable()
										.aspectRatio(contentMode: .fit)
								} placeholder: {
									ProgressView()
								}
								.frame(height: 40)
								.scaledToFit()
								.clipShape(ImgMaskRect())
								.prettyShadow(.tiny)
								Text(game.name)
								Spacer()
								if observableCollection.collection.contains(where: { $0.id == game.id }) {
									Image(systemName: "tray.and.arrow.down")
										.foregroundStyle(Color.accentColor)
								}
							}
						})
						.disabled(observableCollection.collection.contains(where: { $0.id == game.id }))
					}
				}
			}
		}
		.frame(width: 400, height: 500)
	}
	
	func searchAction() {
		loading = true
		getSearchResults(searchString: searchString) { response in
			gameList.removeAll()
			gameList.append(contentsOf: response)
			loading = false
		}
	}
}
