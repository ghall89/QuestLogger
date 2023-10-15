import SwiftUI
import QuestKit
import CachedAsyncImage

struct NewGameView: View {
	@EnvironmentObject var observableCollection: CollectionViewModel
	@EnvironmentObject var globalState: GlobalState

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
							AddGameView(game: game)
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
		.toolbar {
			ToolbarItem(placement: .navigation) {
				Button("Cancel", action: {})
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

struct AddGameView: View {
	@EnvironmentObject var observableCollection: CollectionViewModel
	@EnvironmentObject var globalState: GlobalState
	
	var game: Game
	
	@State private var selectedStatus: Status = .backlog
	@State private var gameDetails: GameDetails?
	@State private var selectedPlatform: String = ""
	
	var body: some View {
		VStack(spacing: 20) {
			CachedAsyncImage(url: getImageURL(imageId: game.cover.image_id)) { image in
				image
					.resizable()
					.aspectRatio(contentMode: .fit)
			} placeholder: {
				ProgressView()
			}
			.frame(maxHeight: .infinity)
			.scaledToFit()
			.clipShape(ImgMaskRect())
			.prettyShadow(.normal)
			Picker("Status", selection: $selectedStatus, content: {
				ForEach(Status.allCases, id: \.self.status, content: {category in
					Text(LocalizedStringKey(category.status)).tag(category)
				})
			})
			PlatformPickerView(selectedPlatform: $selectedPlatform, game: game, gameDetails: gameDetails)
			Button(action: {
				addGame(game: game, collection: &observableCollection.collection, status: selectedStatus, platform: selectedPlatform)
				selectedStatus = .backlog
				globalState.showAddGameSheet.toggle()
			}, label: {
				Text("Add")
					.padding()
			})
			.frame(maxWidth: .infinity)
			.keyboardShortcut(.defaultAction)
		}
		.padding()
		.onAppear {
			getGameById(id: game.id) {result in
				gameDetails = result
				selectedPlatform = result.platforms[0].abbreviation ?? result.platforms[0].name
			}
		}
	}
}
