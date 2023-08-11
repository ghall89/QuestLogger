import Foundation

class ObservableCustomCollection: ObservableObject {
	@Published var collections = [Folder]()
}
