import SwiftUI

struct NewFolderView: View {
	@EnvironmentObject var observableCollection: ObservableCollection

	@AppStorage("colorTheme") var colorTheme: String = "blue"
	@AppStorage("customCollections") var customCollections: [Folder] = []

	@Binding var showNewFolder: Bool
	@Binding var folderId: UUID?

	var colors = AccentColor.allCases.map { "\($0)" }

	private let iconOptions = [
		"folder",
		"folder-fill",
		"archive",
		"controller",
		"controller2",
		"device-mobile",
		"trophy",
		"joystick",
		"star",
		"star-fill",
		"pacman",
		"puzzle",
		"heart",
		"heart-filled",
		"floppy",
		"xbox-a",
		"xbox-b",
		"xbox-x",
		"xbox-y",
		"playstation-circle",
		"playstation-square",
		"playstation-triangle",
		"playstation-x"
	]

	@State var folder: Folder = Folder(name: "", icon: "", color: "", games: [])
	@State var showingAlert: Bool = false

	private func saveFolderAction() {
		folder.name = folder.name.trimmingCharacters(in: .whitespacesAndNewlines)

		if let index = customCollections.firstIndex(where: {$0.id == folder.id}) {
			customCollections[index] = folder
		} else {

			if customCollections.contains(where: {$0.name == folder.name}) {
				showingAlert.toggle()
				return
			}

			customCollections.append(folder)
		}

		showNewFolder.toggle()
	}

	var body: some View {
		NavigationStack {
			Form {
				Section {
					VStack {
						Circle()
							.accentPickerColor(folder.color)
							.frame(width: 82)
							.overlay(content: {
								IconSVG(icon: folder.icon, size: .large)
									.foregroundColor(.white)
							})
							.padding()
						TextField(text: $folder.name, label: {
							Text("Collection Name")
						})
						.multilineTextAlignment(.center)
						.submitLabel(.done)
					}
				}
				Section("Color") {
					ScrollView(.horizontal, showsIndicators: false) {
						LazyHGrid(rows: [GridItem(.flexible(minimum: 0, maximum: .infinity))]) {
							ForEach(colors, id: \.self) {color in
								Button(action: {
									folder.color = color
								}, label: {
									Circle()
										.accentPickerColor(color)
										.frame(width: 34)
								})
								.overlay {
									if folder.color == color {
										IconSVG(icon: "check", size: .small)
									}
								}
							}
						}
						.padding(.horizontal, 25)
						.padding(.vertical, 10)
					}

				}
				Section("Icon") {
					LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5), spacing: 18) {
						ForEach(iconOptions, id: \.self) { option in
							IconSVG(icon: option, size: .large)
								.foregroundColor(option == folder.icon ? .accentColor : .secondary)
								.onTapGesture {
									folder.icon = option
								}
						}
					}
				}
				Section {
					ForEach(folder.games, id: \.self) { gameId in
						if let game = observableCollection.collection.first(where: { $0.id == gameId }) {
							Text(game.name).swipeActions {
								Button(LocalizedStringKey("remove"), role: .destructive) {
									folder.games.removeAll(where: {$0 == gameId})
								}
							}
						}
					}
				}
			}
			.onAppear(perform: {
				if folderId != nil {
					folder = customCollections.first(where: { $0.id == folderId! })!
				} else {
					folder.color = colors.randomElement() ?? "blue"
					folder.icon = iconOptions.randomElement() ?? "folder"
				}
				folderId = nil
			})
			.toolbar {
				ToolbarItem {
					Button(action: {
						showNewFolder.toggle()
					}, label: {
						Text("Cancel")
							.foregroundColor(.accentColor)
					})
				}
				ToolbarItem {
					Button(action: {
						saveFolderAction()
					}, label: {
						IconSVG(icon: "circle-check")
							.foregroundColor(.accentColor)
					})
					.disabled(folder.name.isEmpty)
				}
			}
			.userAccentColor(colorTheme)
			.alert(LocalizedStringKey("folder_exists"), isPresented: $showingAlert) {
				Button("Ok", action: {
					showingAlert.toggle()
				})
			}
		}
	}
}
