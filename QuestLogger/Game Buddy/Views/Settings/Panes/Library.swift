import SwiftUI

struct LibraryPane: View {
	@AppStorage("showArchive") var showArchive: Bool = true
	
	var body: some View {
		VStack {
			Toggle("Show archive", isOn: $showArchive)
			Divider()
			Button("Show in Finder", action: showInFinder)
		}
	}
	
	private func showInFinder() {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let workspace = NSWorkspace.shared
		
		workspace.activateFileViewerSelecting([documentsDirectory])
	}
}
