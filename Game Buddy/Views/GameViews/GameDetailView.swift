import SwiftUI
import SwiftfulLoadingIndicators
import CachedAsyncImage

struct GameDetailView: View {
	@EnvironmentObject var observableCollection: ObservableCollection
	
	@AppStorage("blurBackground") var blurBackground = true
	
	@Binding var selectedGame: Game
	
	@State private var loading: Bool = true
	@State private var gameDetails: GameDetails?
	@State private var isImageLoaded = false
	@State private var showingAlert: Bool = false
	
	var body: some View {
		GeometryReader { geometry in
			ScrollView {
				LazyVStack(alignment: .center) {
					CachedAsyncImage(url: getImageURL(imageId: selectedGame.cover.image_id)) { image in
						image.resizable().aspectRatio(contentMode: .fit)
					} placeholder: {
						LoadingIndicator(animation: .bar, color: .accentColor)
					}
					.frame(height: 300)
					.scaledToFit()
					.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
					.prettyShadow(.normal)
					
					Text(selectedGame.name).fontWeight(.medium).padding().multilineTextAlignment(.center)
					HStack(spacing: 10) {
						
						if selectedGame.in_collection != true {
							Button(action: {
								addGame(game: selectedGame, collection: &observableCollection.collection, status: "backlog")
							}, label: {
								Text("Add to Library")
							})
							Button(action: {
								addGame(game: selectedGame, collection: &observableCollection.collection, status: "wishlist")
							}, label: {
								Text("Add to Wishlist")
							})
						} else {
							Menu(content: {
								StatusMenuView(game: $selectedGame, showingAlert: $showingAlert)
							}, label: {
								Text(LocalizedStringKey(selectedGame.status?.rawValue ?? "Status"))
							})
							Menu(content: {
								ForEach(gameDetails?.platforms ?? []) { platform in
									Button(platform.abbreviation ?? platform.name, action: {
										let platformString = platform.abbreviation ?? platform.name
										updateGamePlatform(id: selectedGame.id, collection: &observableCollection.collection, platform: platformString)
									})
								}
							}, label: {
								Text(selectedGame.platform ?? "Platform")
							})
						}
					}
					.padding()
				}
				.frame(height: geometry.size.height + 30)
			}
		}
		//		.onChange(of: selectedGame) { _ in
		//			loading = true
		//			print("Loading game details...")
		//			getGameById(id: selectedGame.id) {result in
		//				gameDetails = result
		//				loading = false
		//			}
		//		}
	}
}
