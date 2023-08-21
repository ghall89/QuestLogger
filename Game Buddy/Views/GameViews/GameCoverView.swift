import SwiftUI
import CachedAsyncImage

struct GameCoverView: View {
	@EnvironmentObject var observableGameDetails: ObservableGameDetails
	@EnvironmentObject var observableCollection: ObservableCollection
	@AppStorage("preferredColorScheme") var preferredColorScheme: String = "system"
	
	@State private var showingAlert: Bool = false
	@State private var isImageLoaded: Bool = false
	@State private var isHovered: Bool = false
	
	@Binding var game: Game
	
	private let roundedRec: any Shape = RoundedRectangle(cornerRadius: 8, style: .continuous)
	
	var body: some View {
		Button(
			action: {
				observableGameDetails.selectedGame = game
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
					.clipShape(AnyShape(roundedRec))
					.opacity(isHovered ? 0.8 : 1)
					.scaleEffect(isHovered ? 1.01 : 1)
					.overlay(content: {
						if game.id == observableGameDetails.selectedGame?.id {
							AnyShape(roundedRec)
								.stroke(.blue, lineWidth: 3)
						}
					})
					.animation(.easeInOut(duration: 0.1), value: isHovered)
					.onHover(perform: { hovering in
						isHovered.toggle()
					})
					.contextMenu {
						StatusMenuView(game: $game, showingAlert: $showingAlert)
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
