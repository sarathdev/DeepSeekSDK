//
//  DeepSeekError.swift
//  DeepSeekSDK
//
//  Created by Sarath Sasi on 30/01/25.
//

public enum DeepSeekError: Error {
    case invalidAPIKey
    case noData
    case invalidResponse
    case networkError(Error)
}
