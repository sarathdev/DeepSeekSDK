//
//  DeepSeekRequest.swift
//  DeepSeekSDK
//
//  Created by Sarath Sasi on 30/01/25.
//

import Foundation

public struct DeepSeekRequest: Codable {
    let model: String
    let messages: [Message]
    
    public struct Message: Codable {
        let role: String
        let content: String
    }
}


