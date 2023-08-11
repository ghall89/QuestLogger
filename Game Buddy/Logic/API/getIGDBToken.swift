import Foundation
import SwiftUI
import Alamofire

func getIGDBToken(completion: @escaping (Result<String, Error>) -> Void) {
	@AppStorage("twitchClientID") var clientID: String = ""
	@AppStorage("twitchClientSecret") var clientSecret: String = ""
	let url = "https://id.twitch.tv/oauth2/token"

	if let token = loadAccessTokenFromKeychain(), let expirationTime = loadExpirationTimeFromKeychain(), expirationTime > Date().timeIntervalSince1970 {
		completion(.success(token))
		return
	}

	let parameters: Parameters = [
		"client_id": clientID,
		"client_secret": clientSecret,
		"grant_type": "client_credentials"
	]

	AF.request(url, method: .post, parameters: parameters)
		.validate(statusCode: 200..<300)
		.responseJSON { response in
			switch response.result {
				case .success(let value):
					if let json = value as? [String: Any], let token = json["access_token"] as? String, let expiresIn = json["expires_in"] as? Double {
						// Cache the token and its expiration time in the Keychain
						saveAccessTokenToKeychain(token: token)
						saveExpirationTimeToKeychain(expirationTime: Date().timeIntervalSince1970 + expiresIn)
						completion(.success(token))
					} else {
						completion(.failure(NSError(domain: "Unknown Error", code: 0, userInfo: nil)))
					}
				case .failure(let error):
					completion(.failure(error))
			}
		}
}

func saveAccessTokenToKeychain(token: String) {
	let query: [String: Any] = [
		kSecClass as String: kSecClassGenericPassword as String,
		kSecAttrAccount as String: "igdbToken",
		kSecValueData as String: token.data(using: .utf8)!,
		kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
	]
	SecItemAdd(query as CFDictionary, nil)
}

func loadAccessTokenFromKeychain() -> String? {
	let query: [String: Any] = [
		kSecClass as String: kSecClassGenericPassword as String,
		kSecAttrAccount as String: "igdbToken",
		kSecReturnData as String: true,
		kSecMatchLimit as String: kSecMatchLimitOne
	]
	var result: AnyObject?
	let status = SecItemCopyMatching(query as CFDictionary, &result)
	if status == errSecSuccess, let data = result as? Data, let token = String(data: data, encoding: .utf8) {
		return token
	} else {
		return nil
	}
}

func saveExpirationTimeToKeychain(expirationTime: Double) {
	var expiration = expirationTime
	let query: [String: Any] = [
		kSecClass as String: kSecClassGenericPassword as String,
		kSecAttrAccount as String: "igdbTokenExpirationTime",
		kSecValueData as String: Data(bytes: &expiration, count: MemoryLayout<Double>.size),
		kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
	]
	SecItemAdd(query as CFDictionary, nil)
}

func loadExpirationTimeFromKeychain() -> Double? {
	let query: [String: Any] = [
		kSecClass as String: kSecClassGenericPassword as String,
		kSecAttrAccount as String: "igdbTokenExpirationTime",
		kSecReturnData as String: true,
		kSecMatchLimit as String: kSecMatchLimitOne
	]
	var result: AnyObject?
	let status = SecItemCopyMatching(query as CFDictionary, &result)
	if status == errSecSuccess, let data = result as? Data {
		let expirationTime = data.withUnsafeBytes { $0.load(as: Double.self) }
		return expirationTime
	} else {
		return nil
	}
}
