import SwiftUI
import MarkdownUI
import SwiftfulLoadingIndicators
import CachedAsyncImage
import QuestKit
import PopupView

struct GameDetailView: View {
	@EnvironmentObject var observableCollection: CollectionViewModel
	
	@AppStorage("blurBackground") var blurBackground = true
	
	@Binding var selectedGame: Game
	
	@State private var isImageLoaded = false
	@State private var gameStatus: Status?
	@State private var showingAlert: Bool = false
	@State private var showAddGame: Bool = false
	@State private var showEditInfo: Bool = false
	@State private var showPopup: Bool = false
	
	var body: some View {
		GeometryReader { geometry in
			ScrollView {
				LazyVStack(alignment: .center) {
					CachedAsyncImage(url: getImageURL(imageId: selectedGame.cover.image_id)) { image in
						image
							.resizable()
							.aspectRatio(contentMode: .fit)
					} placeholder: {
						LoadingIndicator(animation: .bar, color: .accentColor)
					}
					.frame(height: 300)
					.scaledToFit()
					.clipShape(ImgMaskRect())
					.prettyShadow(.normal)
					
					Text(selectedGame.name)
						.font(.title2)
						.padding()
						.multilineTextAlignment(.center)
					Text(selectedGame.platform ?? "")
						.font(.subheadline)
					HStack(spacing: 10) {
						
						if selectedGame.in_collection != true {
							Button(action: {
								showAddGame.toggle()
							}, label: {
								Label("Add to Library", systemImage: "plus")
							})
						} else {
							Menu(content: {
								StatusMenu(game: $selectedGame, showingAlert: $showingAlert)
							}, label: {
								Text(LocalizedStringKey(selectedGame.status?.status ?? "Status"))
							})
							Button(action: {
								showEditInfo.toggle()
							}, label: {
								Image(systemName: "pencil")
							})
						}
					}
					.padding()
					if selectedGame.in_collection == true {
						StarRatingView(game: $selectedGame)
						if selectedGame.notes != nil && selectedGame.notes != "" {
							
							VStack(alignment: .leading, spacing: 10) {
								Text("Note:")
									.font(.headline)
								Markdown(selectedGame.notes ?? "")
									.multilineTextAlignment(.leading)
									.frame(maxWidth: .infinity)
							}
							.frame(maxWidth: .infinity)
							.padding()
						}
					}
					
				}
				.frame(height: geometry.size.height + 30)
			}
		}
		.sheet(isPresented: $showEditInfo, content: {
			EditGameView(game: selectedGame, show: $showEditInfo)
		})
		.sheet(isPresented: $showAddGame, content: {
			AddGameView(showAddGame: $showAddGame, showConfirmation: $showPopup, game: selectedGame)
		})
		.popup(isPresented: $showPopup) {
			Text("Added to Library")
				.frame(maxWidth: .infinity)
				.frame(height: 30)
				.background(.secondary)
		} customize: {
			$0
				.type(.toast)
				.position(.bottom)
				.closeOnTapOutside(true)
				.autohideIn(2)
		}
	}
}
