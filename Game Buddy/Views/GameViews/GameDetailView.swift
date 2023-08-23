import SwiftUI
import SwiftfulLoadingIndicators
import CachedAsyncImage

struct AddGameView: View {
	@EnvironmentObject var observableCollection: ObservableCollection
	@Binding var showAddGame: Bool
	var game: Game
	
	@State private var selectedStatus: Category = .backlog
	@State var gameDetails: GameDetails?
	@State var selectedPlatform: String = ""
	
	var body: some View {
		VStack(spacing: 20) {
			Picker("Status", selection: $selectedStatus, content: {
				ForEach(Category.allCases, id: \.self.status, content: {category in
					Text(LocalizedStringKey(category.status)).tag(category)
				})
			})
			PlatformPickerView(selectedPlatform: $selectedPlatform, game: game, gameDetails: gameDetails)
			HStack {
				Spacer()
				Button(action: {
					showAddGame.toggle()
					selectedStatus = .backlog
				}, label: {
					Text("Cancel")
				})
				Button(action: {
					addGame(game: game, collection: &observableCollection.collection, status: selectedStatus.status, platform: selectedPlatform)
					showAddGame.toggle()
					selectedStatus = .backlog
				}, label: {
					Text("Add")
				})
				.keyboardShortcut(.defaultAction)
			}
		}
		.padding()
		.frame(width: 300)
		.onAppear {
			getGameById(id: game.id) {result in
				gameDetails = result
				selectedPlatform = result.platforms[0].abbreviation ?? result.platforms[0].name
			}
		}
	}
}

struct GameDetailView: View {
	@EnvironmentObject var observableCollection: ObservableCollection
	
	@AppStorage("blurBackground") var blurBackground = true
	
	@Binding var selectedGame: Game
	
	@State private var isImageLoaded = false
	@State private var gameStatus: Category?
	@State private var showingAlert: Bool = false
	@State private var showAddGame: Bool = false
	@State private var showEditInfo: Bool = false
	
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
								StatusMenuView(game: $selectedGame, showingAlert: $showingAlert)
							}, label: {
								Text(LocalizedStringKey(selectedGame.status?.rawValue ?? "Status"))
							})
							Button(action: {
								showEditInfo.toggle()
							}, label: {
								Image(systemName: "pencil")
							})
						}
					}
					.padding()
					
					Text("Note:")
						.font(.title3)
					Text(selectedGame.notes ?? "")
					
				}
				.frame(height: geometry.size.height + 30)
			}
		}
		.sheet(isPresented: $showEditInfo, content: {
			EditGameView(game: selectedGame, show: $showEditInfo)
		})
		.sheet(isPresented: $showAddGame, content: {
			AddGameView(showAddGame: $showAddGame, game: selectedGame)
		})
	}
}
