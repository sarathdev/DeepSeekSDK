//
//  Untitled.swift
//  DeepSeekSDK
//
//  Created by Sarath Sasi on 30/01/25.
//

public struct DeepSeekResponse: Codable {
    let choices: [Choice]
    
    public struct Choice: Codable {
        let message: Message
    }
    
    public struct Message: Codable {
        let content: String
    }
}


