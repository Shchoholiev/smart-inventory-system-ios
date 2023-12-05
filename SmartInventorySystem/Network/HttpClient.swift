//
//  HttpClient.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/3/23.
//

import Foundation

class HttpClient: ObservableObject {
    
    static let shared = HttpClient()
    
    private let baseUrl = URL(string: "https://smart-inventory-system.azurewebsites.net")!
    
    private let jwtTokensService = JwtTokensService()
    
    private var accessToken: String?
    
    @Published var isAuthenticated = false
    
    func getAsync<TOut: Decodable>(_ path: String) async throws -> TOut {
        await self.checkAccessTokenAsync()
        return try await sendAsync(path, nil as Dummy?, .get)
    }
    
    func postAsync<TIn: Encodable, TOut: Decodable>(_ path: String, _ data: TIn) async throws -> TOut {
        await self.checkAccessTokenAsync()
        return try await sendAsync(path, data, .post)
    }
    
    func putAsync<TIn: Encodable, TOut: Decodable>(_ path: String, _ data: TIn) async throws -> TOut {
        await self.checkAccessTokenAsync()
        return try await sendAsync(path, data, .put)
    }
    
    func logout() {
        isAuthenticated = false
        jwtTokensService.clearTokensInKeychain()
        accessToken = nil
        UserDefaults.standard.removeObject(forKey: "groupId")
    }
    
    // TODO: move to global user
    func setAuthenticated(_ value: Bool) async {
        // UI updates must be done in main thread
        await MainActor.run {
            isAuthenticated = value
        }
    }
    
    func checkAuthentication() async {
        await checkAccessTokenAsync()
    }
    
    private func sendAsync<TIn: Encodable, TOut: Decodable>(_ path: String, _ data: TIn?, _ httpMethod: HttpMethod) async throws -> TOut {
        do {
            var request = URLRequest(url: baseUrl.appendingPathComponent(path))
            print(baseUrl.appendingPathComponent(path))
            request.httpMethod = httpMethod.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let jwt = accessToken {
                request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
            }
            
            if let inputData = data {
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(data)
                request.httpBody = jsonData
                
                let jsonDataStr = String(data: jsonData, encoding: .utf8 )
                print("sendAsync input")
                print(jsonDataStr)
            }
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as! HTTPURLResponse
            if !(200...299).contains(httpResponse.statusCode) {
                print("Response HTTP Status code: \(httpResponse.statusCode)")
                
                let httpError = try decoder.decode(HttpError.self, from: data)
                throw httpError
            }
            
            let str = String(data: data, encoding: .utf8 )
            print("sendAsync result")
            print(str)
            
            let object = try decoder.decode(TOut.self, from: data)
            
            return object
        } catch {
            print(error)
            throw error
        }
    }
    
    private func checkAccessTokenAsync() async {
        var tokensModel: TokensModel? = nil
        if jwtTokensService.isExpired() {
            tokensModel = await getTokensAsync()
            if let tokens = tokensModel {
                jwtTokensService.storeTokensInKeychain(tokens: tokens)
            }
        } else {
            tokensModel = jwtTokensService.getTokensFromKeychain()
        }
        if let tokens = tokensModel {
            GlobalUser.shared.setUserFromJwt(tokens.accessToken)
            accessToken = tokens.accessToken
            await setAuthenticated(true)
        } else {
            await setAuthenticated(false)
        }
    }
    
    private func getTokensAsync() async -> TokensModel? {
        let tokensModel = jwtTokensService.getTokensFromKeychain()
        if let tokens = tokensModel, !tokens.accessToken.isEmpty, !tokens.refreshToken.isEmpty {
            return await refreshTokens(tokens)
        }
        
        return nil
    }
    
    
    private func refreshTokens(_ tokens: TokensModel) async -> TokensModel? {
        do {
            let tokens: TokensModel = try await sendAsync("/tokens/refresh", tokens, .post)
            return tokens
        } catch {
            print("An error occurred: \(error)")
            return nil
        }
    }
    
    private func convertPascalToCamelCase(_ pascalKey: String) -> String {
        let firstChar = pascalKey.prefix(1).lowercased()
        let otherChars = pascalKey.dropFirst()
        return "\(firstChar)\(otherChars)"
    }
    
    struct AnyCodingKey: CodingKey {
        let stringValue: String
        let intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }

        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

//MARK: - Used to pass empty data in sendAsync() from getAsync()
struct Dummy: Encodable {
}
