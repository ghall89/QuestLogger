import Foundation

public func getImageURL(imageId: String) -> URL {
	let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	let fileURL = documentsDirectory.appendingPathComponent("img/\(imageId).png")
	if FileManager.default.fileExists(atPath: fileURL.path) {
		return fileURL
	}
	return URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/\(imageId).png")!
}
