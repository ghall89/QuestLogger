import SwiftUI
import CachedAsyncImage

struct GameCoverView: View {
	@EnvironmentObject var observableGameDetails: ObservableGameDetails
	@EnvironmentObject var observableCollection: ObservableCollection
	@AppStorage("preferredColorScheme") var preferredColorScheme: String = "system"
	
	@State var showingAlert: Bool = false
	@State var isImageLoaded: Bool = false
	
	@Binding var game: Game
	
	var body: some View {
		Button(
			action: {
				observableGameDetails.selectedGame = game
				observableGameDetails.detailSliderOpen.toggle()
			}, label: {
				VStack {
					AsyncImage(url: getImageURL(imageId: game.cover.image_id)) { image in
						image.resizable()
							.aspectRatio(3/4, contentMode: .fit)
							.opacity(isImageLoaded ? 1 : 0)
							.onAppear {
								withAnimation(.easeInOut(duration: 0.5)) {
									isImageLoaded = true
								}
							}
					} placeholder: {
						Rectangle()
							.fill(.clear)
							.aspectRatio(3/4, contentMode: .fill)
							.frame(maxWidth: .infinity)
					}
					.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
					.contextMenu {
						StatusMenuView(game: $game, showingAlert: $showingAlert, dismissSheet: nil)
					}
					.prettyShadow(.tiny)
					Text(game.name)
						.fontWeight(.bold)
						.multilineTextAlignment(.center)
				}
			})
		.buttonStyle(.plain)
		.alert(LocalizedStringKey("confirmDeleteTitle"), isPresented: $showingAlert) {
			Button(LocalizedStringKey("delete"), role: .destructive, action: {
				removeGame(id: game.id, collection: &observableCollection.collection)
			})
			Button(LocalizedStringKey("cancel"), role: .cancel, action: {})
		} message: {
			Text(LocalizedStringKey("confirmDeleteMessage"))
		}
	}
}
