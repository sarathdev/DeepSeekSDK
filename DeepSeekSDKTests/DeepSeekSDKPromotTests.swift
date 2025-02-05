//
//  DeepSeekSDKPromotTests.swift
//  DeepSeekSDKTests
//
//  Created by Sarath Sasi on 05/02/25.
//

import Testing
import XCTest

@testable import DeepSeekSDK

final class DeepSeekSDKPromotTests: XCTestCase {
   var client: DeepSeekClient!
   
   override func setUp() {
       super.setUp()
       client = DeepSeekClient(apiKey: "YOUR_API_KEY")
   }
   
   override func tearDown() {
       client = nil
       super.tearDown()
   }
   
   func testSendPrompt() {
       let expectation = expectation(description: "Basic API Call")
       
       client.sendPrompt("Say 'Hello, this is a test response'") { result in
           switch result {
           case .success(let response):
               print("Basic API Response:", response)
               XCTAssertFalse(response.isEmpty, "Response should not be empty")
               expectation.fulfill()
               
           case .failure(let error):
               XCTFail("Basic API call failed: \(error.localizedDescription)")
           }
       }
       
       waitForExpectations(timeout: 30)
   }
   
   func testMultiplePrompts() {
       let expectation1 = expectation(description: "First API Call")
       let expectation2 = expectation(description: "Second API Call")
       
       // First prompt - Mathematical question
       client.sendPrompt("What is 2+2? Provide only the numerical answer.") { result in
           switch result {
           case .success(let response):
               print("Math Response:", response)
               XCTAssertFalse(response.isEmpty)
               expectation1.fulfill()
           case .failure(let error):
               XCTFail("Math API call failed: \(error.localizedDescription)")
           }
       }
       
       // Second prompt - Identity question
       client.sendPrompt("Who are you? Provide a brief response.") { result in
           switch result {
           case .success(let response):
               print("Identity Response:", response)
               XCTAssertFalse(response.isEmpty)
               expectation2.fulfill()
           case .failure(let error):
               XCTFail("Identity API call failed: \(error.localizedDescription)")
           }
       }
       
       waitForExpectations(timeout: 30)
   }
   
   func testLongPrompt() {
       let expectation = expectation(description: "Long Prompt API Call")
       
       let longPrompt = """
       Please analyze this text in detail:
       Lorem ipsum dolor sit amet, consectetur adipiscing elit.
       Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
       Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.
       Provide a brief analysis focusing on key themes and structure.
       """
       
       client.sendPrompt(longPrompt) { result in
           switch result {
           case .success(let response):
               print("Long Text Response:", response)
               XCTAssertFalse(response.isEmpty)
               XCTAssertTrue(response.count > 50, "Long prompt should generate substantial response")
               expectation.fulfill()
           case .failure(let error):
               XCTFail("Long text API call failed: \(error.localizedDescription)")
           }
       }
       
       waitForExpectations(timeout: 30)
   }
   
   func testEmptyPrompt() {
       let expectation = expectation(description: "Empty Prompt API Call")
       
       client.sendPrompt("") { result in
           switch result {
           case .success(let response):
               print("Empty Prompt Response:", response)
               XCTFail("Empty prompt should not succeed")
           case .failure(let error):
               print("Expected error for empty prompt:", error.localizedDescription)
               expectation.fulfill()
           }
       }
       
       waitForExpectations(timeout: 30)
   }
   
    func testConcurrentPrompts() {
        let numberOfPrompts = 3
        let expectations = (0..<numberOfPrompts).map { expectation(description: "Concurrent Call \($0)") }
        
        // Create a DispatchGroup to manage concurrent calls
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.deepseeksdk.tests", attributes: .concurrent)
        
        for i in 0..<numberOfPrompts {
            group.enter()
            queue.async {
                let prompt = "Give me a one-word response to: What is \(i+1)?"
                
                self.client.sendPrompt(prompt) { result in
                    defer { group.leave() }
                    
                    switch result {
                    case .success(let response):
                        print("Concurrent Response \(i):", response)
                        XCTAssertFalse(response.isEmpty)
                        expectations[i].fulfill()
                    case .failure(let error):
                        // Log more details about the error
                        print("Error details for call \(i):", error)
                        if let nsError = error as? NSError {
                            print("Error domain:", nsError.domain)
                            print("Error code:", nsError.code)
                            print("Error user info:", nsError.userInfo)
                        }
                        XCTFail("Concurrent API call \(i) failed: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        // Add a small delay between requests to prevent rate limiting
        queue.asyncAfter(deadline: .now() + 0.5) {
            // Optional: Add additional handling here
        }
        
        // Wait for all expectations with a longer timeout
        waitForExpectations(timeout: 60) { error in
            if let error = error {
                print("Test timeout error:", error.localizedDescription)
            }
        }
        
        // Ensure all requests are completed
        group.wait()
    }
    
    func testSequentialMultiplePrompts() {
        let expectation = expectation(description: "Sequential Multiple Prompts")
        expectation.expectedFulfillmentCount = 3
        
        // First prompt
        client.sendPrompt("Count to one") { result in
            switch result {
            case .success(let response):
                print("First response:", response)
                XCTAssertFalse(response.isEmpty)
                expectation.fulfill()
                
                // Second prompt only after first succeeds
                self.client.sendPrompt("Count to two") { result in
                    switch result {
                    case .success(let response):
                        print("Second response:", response)
                        XCTAssertFalse(response.isEmpty)
                        expectation.fulfill()
                        
                        // Third prompt only after second succeeds
                        self.client.sendPrompt("Count to three") { result in
                            switch result {
                            case .success(let response):
                                print("Third response:", response)
                                XCTAssertFalse(response.isEmpty)
                                expectation.fulfill()
                            case .failure(let error):
                                XCTFail("Third call failed: \(error.localizedDescription)")
                            }
                        }
                    case .failure(let error):
                        XCTFail("Second call failed: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                XCTFail("First call failed: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 60)
    }
    
   
   func testErrorHandling() {
       let expectation = expectation(description: "Error Handling Test")
       
       // Create a client with invalid API key to test error handling
       let invalidClient = DeepSeekClient(apiKey: "invalid_api_key")
       
       invalidClient.sendPrompt("Test prompt") { result in
           switch result {
           case .success:
               XCTFail("Should not succeed with invalid API key")
           case .failure(let error):
               print("Expected error with invalid API key:", error.localizedDescription)
               expectation.fulfill()
           }
       }
       
       waitForExpectations(timeout: 30)
   }
   
   func testSpecialCharacters() {
       let expectation = expectation(description: "Special Characters Test")
       
       let promptWithSpecialChars = """
       Test with special characters: 
       !@#$%^&*()_+-=[]{}|;:'",./<>?
       Numbers: 1234567890
       Emojis: 😀🤖🌟🎉
       """
       
       client.sendPrompt(promptWithSpecialChars) { result in
           switch result {
           case .success(let response):
               print("Special Characters Response:", response)
               XCTAssertFalse(response.isEmpty)
               expectation.fulfill()
           case .failure(let error):
               XCTFail("Special characters API call failed: \(error.localizedDescription)")
           }
       }
       
       waitForExpectations(timeout: 30)
   }
}
