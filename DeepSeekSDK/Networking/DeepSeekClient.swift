//
//  DeepSeekClient.swift
//  DeepSeekSDK
//
//  Created by Sarath Sasi on 30/01/25.
//

import Foundation

public class DeepSeekClient {
    private let apiKey: String
    private let baseURL = URL(string: "https://api.deepseek.com/v1/chat/completions")!
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func sendPrompt(_ prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "deepseek-v3",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7,
            "max_tokens": 1000
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
                
            if let requestString = String(data: jsonData, encoding: .utf8) {
                print("Request body:", requestString)
            }
        } catch {
            print("JSON serialization error:", error)
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code:", httpResponse.statusCode)
                print("Response Headers:", httpResponse.allHeaderFields)
            }
            
            if let error = error {
                print("Network error:", error)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "NoData", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])
                print("No data error")
                completion(.failure(error))
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw response:", responseString)
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Check for API error response
                    if let error = jsonResponse["error"] as? [String: Any],
                       let message = error["message"] as? String {
                        let apiError = NSError(domain: "DeepSeekAPI",
                                             code: -1,
                                             userInfo: [NSLocalizedDescriptionKey: message])
                        print("API error:", message)
                        completion(.failure(apiError))
                        return
                    }
                    
                    // Parse success response
                    if let choices = jsonResponse["choices"] as? [[String: Any]],
                       let message = choices.first?["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        print("Success: parsed content")
                        completion(.success(content))
                    } else {
                        let error = NSError(domain: "InvalidResponse",
                                          code: -1,
                                          userInfo: [NSLocalizedDescriptionKey: "Unable to parse response content"])
                        print("Parse error: Invalid response structure")
                        completion(.failure(error))
                    }
                }
            } catch {
                print("JSON parsing error:", error)
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
