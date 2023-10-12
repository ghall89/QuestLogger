import SwiftUI
import CachedAsyncImage
import QuestKit

struct EditGameView: View {
	@EnvironmentObject var observableCollection: CollectionViewModel
	
	var game: Game
	
	@Binding var show: Bool
	
	@State var gameDetails: GameDetails?
	@State private var gameTitle: String = ""
	@State private var selectedPlatform: String = ""
	@State private var noteBody: String = ""
	
	var body: some View {
		VStack(spacing: 20) {
			HStack(spacing: 10) {
				VStack {
					CachedAsyncImage(url: getImageURL(imageId: game.cover.image_id)) { image in
						image.resizable().aspectRatio(contentMode: .fit)
					} placeholder: {
						ProgressView()
					}
					.frame(width: 200)
					.scaledToFit()
				}
				Form {
					TextField("Title", text: $gameTitle)
						.textFieldStyle(.roundedBorder)
					Picker("Platform", selection: $selectedPlatform, content: {
						if gameDetails != nil {
							ForEach(gameDetails?.platforms ?? []) { platform in
								Text(platform.abbreviation ?? platform.name).tag(platform.abbreviation ?? platform.name)
							}
						} else if game.platform != nil {
							Text(game.platform!).tag(game.platform!)
						}
					})
					TextEditor(text: $noteBody)
						.frame(height: 100)
						.textFieldStyle(.roundedBorder)
						.border(.quaternary, width: 1)
					Text("Tip: You can use Markdown!")
						.font(.footnote)
				}
			}
			HStack {
				Spacer()
				Button(action: {
					show.toggle()
				}, label: {
					Text("Cancel")
				})
				Button(action: saveChanges, label: {
					Text("Save")
				})
				.keyboardShortcut(.defaultAction)
				.disabled(gameTitle.isEmpty)
			}
		}
		.frame(width: 600)
		.padding()
		.onAppear {
			getGameDetails()
			
			gameTitle = game.name
			selectedPlatform = game.platform ?? ""
			noteBody = game.notes ?? ""
		}
	}
	
	private func saveChanges() {
		if selectedPlatform != game.platform {
			updateGame(id: game.id, collection: &observableCollection.collection, platform: selectedPlatform)
		}
		if noteBody != game.notes {
			updateGame(id: game.id, collection:  &observableCollection.collection, note: noteBody)
		}
		
		show.toggle()
	}
	
	private func getGameDetails() {
		print("Loading game details...")
		getGameById(id: game.id) {result in
			gameDetails = result
		}
	}
}
