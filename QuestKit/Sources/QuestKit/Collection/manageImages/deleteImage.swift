import Foundation

public func deleteImage(imageId: String) {
	let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	let imgDirectory = documentsDirectory.appendingPathComponent("img")

	let filePath = imgDirectory.appendingPathComponent("\(imageId).png")
	do {
		try FileManager.default.removeItem(at: filePath)
	} catch {
		print("Error deleting file: \(error)")
	}
}
