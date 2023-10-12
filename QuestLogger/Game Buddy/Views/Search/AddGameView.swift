import SwiftUI
import QuestKit
import CachedAsyncImage

struct AddGameView: View {
	@EnvironmentObject var observableCollection: CollectionViewModel
	var game: Game
	@Binding var showSheet: Bool
	
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
				showSheet.toggle()
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
