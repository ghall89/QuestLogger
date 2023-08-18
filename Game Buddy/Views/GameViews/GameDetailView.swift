import SwiftUI
import SwiftfulLoadingIndicators
import CachedAsyncImage

struct GameDetailView: View {
	@EnvironmentObject var observableCollection: ObservableCollection
	
	@Environment(\.dismiss) var dismiss
	@Environment(\.presentationMode) var presentationMode
	
	@AppStorage("blurBackground") var blurBackground = true
	
	@Binding var selectedGame: Game
	
	@State private var loading: Bool = true
	@State private var gameDetails: GameDetails?
	@State private var isImageLoaded = false
	@State private var showingAlert: Bool = false
	
	
	func dismissSheet() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	var body: some View {
		
		ZStack(alignment: .top) {
			if loading == false {
				AsyncImage(url: URL(string: "https://images.igdb.com/igdb/image/upload/t_screenshot_med/\(String(describing: gameDetails!.screenshots[0].image_id)).png")) { image in
					image
						.resizable()
						.aspectRatio(contentMode: .fit)
						.blur(radius: blurBackground ? 14 : 0, opaque: true)
						.mask(
							LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5), .blue.opacity(0)]), startPoint: .top, endPoint: .bottom)
						)
						.opacity(isImageLoaded ? 1 : 0)
						.onAppear {
							withAnimation(.easeInOut(duration: 0.5)) {
								isImageLoaded = true
							}
						}
				} placeholder: {
					
				}
				.frame(maxWidth: .infinity)
			}
			
			GeometryReader { geometry in
				VStack {
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
									dismissSheet()
								}, label: {
									Text("Add to Library")
								})
								Button(action: {
									addGame(game: selectedGame, collection: &observableCollection.collection, status: "wishlist")
									dismissSheet()
								}, label: {
									Text("Add to Wishlist")
								})
							} else {
								Menu(content: {
									StatusMenuView(game: $selectedGame, showingAlert: $showingAlert, dismissSheet: dismissSheet)
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
			
			HStack() {
				Button(action: dismissSheet, label: {
					Image(systemName: "xmark.circle.fill")
						.font(.title2)
				})
				.buttonStyle(.plain)
				.padding()
				.focusable(false)
				Spacer()
			}
		}
		.frame(width: 400, height: 500)
		.onAppear {
			print("Loading game details...")
			getGameById(id: selectedGame.id) {result in
				gameDetails = result
				loading = false
			}
		}
	}
}
