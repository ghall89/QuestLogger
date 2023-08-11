import SwiftUI

extension Array: RawRepresentable where Element: Codable {
	public init?(rawValue: String) {
		guard let data = rawValue.data(using: .utf8),
					let result = try? JSONDecoder().decode([Element].self, from: data)
		else {
			return nil
		}
		self = result
	}

	public var rawValue: String {
		guard let data = try? JSONEncoder().encode(self),
					let result = String(data: data, encoding: .utf8)
		else {
			return "[]"
		}
		return result
	}
}

struct CollectionView: View {
	@AppStorage("customCollections") var customCollections: [Folder] = []
	@State var collectionSearch: String = ""
	@State private var showNewFolder: Bool = false
	@State var folderToEdit: UUID?

	let categories: [Category] = [.wishlist, .backlog, .nowPlaying, .finished, .archived]

	var body: some View {
			if collectionSearch.isEmpty {
				List {
					NavigationLink(destination: {
						SearchView()
					}, label: {
						Label("Search Games", systemImage: "magnifyingglass")
					})
					Section("Library") {
						ForEach(categories, id: \.self) { category in
							FolderLinkView(category: category.status, icon: category.icon)
						}
					}
				}
				if customCollections.count >= 1 {
					HStack {
						Text(LocalizedStringKey("folders"))
							.padding(.leading)
						Spacer()
					}
					LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 10) {
						ForEach(customCollections) { folder in
							FolderLinkView(category: folder.name, icon: folder.icon, folderId: folder.id)
								.contextMenu(menuItems: {
									Button(action: {
										folderToEdit = folder.id
										showNewFolder.toggle()
									}, label: {
										Text(LocalizedStringKey("edit"))
										IconSVG(icon: "pencil")
									})
									Button(role: .destructive, action: {
										if let folderIndex = customCollections.firstIndex(where: { $0.id == folder.id }) {
											customCollections.remove(at: folderIndex)
										}
									}, label: {
										Text(LocalizedStringKey("delete"))
										IconSVG(icon: "trash")
									})
								})
						}
					}
					.animation(.easeInOut, value: customCollections)
					.padding(.horizontal)
				}
			}
		}
//		.toolbar {
//			ToolbarItem {
//				HStack(alignment: .top) {
//					Button(action: {
//						showNewFolder.toggle()
//					}, label: {
//						IconSVG(icon: "folder-plus")
//					})
//				}
//			}
//		}
//		.sheet(isPresented: $showNewFolder) {
//			NewFolderView(showNewFolder: $showNewFolder, folderId: $folderToEdit)
//		}
	}

