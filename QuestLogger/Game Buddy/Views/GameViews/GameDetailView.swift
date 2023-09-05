import SwiftUI
import MarkdownUI
import SwiftfulLoadingIndicators
import CachedAsyncImage
import QuestKit

struct StarRatingView: View {
	@EnvironmentObject var observableCollection: ObservableCollection
	@Binding var game: Game
	@State private var hoverState: HoverState = HoverState(hover: false, value: 0)
	
	var body: some View {
		HStack {
			ForEach(1...5, id: \.self) { num in
				Image(systemName: starIsActive(value: num) ? "star.fill" : "star")
					.font(.system(size: 16))
					.foregroundColor(.yellow)
					.onTapGesture {
						updateGame(id: game.id, collection: &observableCollection.collection, rating: num == game.rating ? 0 : num)
					}
					.onHover(perform: { hovering in
						hoverState.hover.toggle()
						hoverState.value = num
					})
					.scaleEffect(hoverState.hover && hoverState.value == num ? 1.1 : 1)
			}
		}
		.padding()
	}
	
	private func starIsActive(value: Int) -> Bool {
		if hoverState.hover && hoverState.value >= value {
			return true
		}
		
		if game.rating ?? 0 >= value {
			return true
		}
		
		return false
	}
	
	private struct HoverState {
		var hover: Bool
		var value: Int
	}
}


struct AddGameView: View {
	@EnvironmentObject var observableCollection: ObservableCollection
	@Binding var showAddGame: Bool
	var game: Game
	
	@State private var selectedStatus: Status = .backlog
	@State var gameDetails: GameDetails?
	@State var selectedPlatform: String = ""
	
	var body: some View {
		VStack(spacing: 20) {
			Picker("Status", selection: $selectedStatus, content: {
				ForEach(Status.allCases, id: \.self.status, content: {category in
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
					addGame(game: game, collection: &observableCollection.collection, status: selectedStatus, platform: selectedPlatform)
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
	@State private var gameStatus: Status?
	@State private var showingAlert: Bool = false
	@State private var showAddGame: Bool = false
	@State private var showEditInfo: Bool = false
	
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
								StatusMenuView(game: $selectedGame, showingAlert: $showingAlert)
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
			AddGameView(showAddGame: $showAddGame, game: selectedGame)
		})
	}
}
