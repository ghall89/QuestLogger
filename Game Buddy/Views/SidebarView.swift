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

struct SidebarView: View {
	@AppStorage("customCollections") var customCollections: [Folder] = []
	@AppStorage("sidebarSelection") var sidebarSelection: String = "backlog"
	@State var collectionSearch: String = ""
	@State private var showNewFolder: Bool = false
	@State var folderToEdit: UUID?
	
	let categories: [Category] = [.wishlist, .backlog, .nowPlaying, .finished, .archived]
	
	var body: some View {
		
		List(selection: $sidebarSelection) {
			NavigationLink(destination: {
				SearchView()
			}, label: {
				Label("Search Games", systemImage: "magnifyingglass")
			})
			.id("search")
			Section("Library") {
				ForEach(categories, id: \.self.status) { category in
					FolderLinkView(category: category.status, icon: category.icon)
				}
			}
			if customCollections.count >= 1 {
				Section("Folders") {
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
			}
		}
		.toolbar {
			ToolbarItem {
				Button(action: {
//					showNewFolder.toggle()
				}, label: {
					Image(systemName: "folder.badge.plus")
				})
				
			}
		}
		.sheet(isPresented: $showNewFolder) {
			NewFolderView(showNewFolder: $showNewFolder, folderId: $folderToEdit)
		}
	}
}

