//
//  DeepSeekSDKTests.swift
//  DeepSeekSDKTests
//
//  Created by Sarath Sasi on 30/01/25.
//

import XCTest
@testable import DeepSeekSDK

final class DeepSeekSDKTests: XCTestCase {
    func testSendPrompt() {
        let client = DeepSeekClient(apiKey: "test_api_key")
        let expectation = self.expectation(description: "Fetch response")
        
        client.sendPrompt("Hello, DeepSeek!") { result in
            switch result {
            case .success(let response):
                XCTAssertFalse(response.isEmpty)
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
