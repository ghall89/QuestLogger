import Foundation
import SwiftUI

public func getImageURL(imageId: String) -> URL {
	@AppStorage("customDirectoryURL") var customDirectoryURL: URL = URL(string: "~/Documents")!

	var fileURL = customDirectoryURL
	fileURL.append(path: "Library.quest/img/\(imageId).png")
	
	if FileManager.default.fileExists(atPath: fileURL.path) {
		return fileURL
	}
	return URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/\(imageId).png")!
}
