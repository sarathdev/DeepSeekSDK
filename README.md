# DeepSeekSDK

`DeepSeekSDK` is a lightweight and easy-to-use iOS SDK that allows developers to integrate the **DeepSeek API** into their applications. With this SDK, you can send prompts to DeepSeek and receive responses programmatically, enabling seamless integration of AI-powered conversational features.

## Features
- **Simple Integration**: Easily send prompts and receive responses from DeepSeek.
- **Error Handling**: Robust error handling for network and API errors.
- **Customizable**: Supports customizable request parameters (e.g., model, temperature).
- **Swift Package Manager (SPM) Support**: Integrate the SDK into your project using SPM.
- **Unit Tests**: Includes unit tests for reliable and maintainable code.

## Requirements
- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## Installation

### Swift Package Manager (SPM)
1. Open your Xcode project.
2. Go to **File > Add Packages**.
3. Enter the repository URL: `https://github.com/sarathdev/DeepSeekSDK.git`.
4. Select the version you want to use (e.g., `1.0.0`).
5. Click **Add Package**.

## Usage

### 1. Import the SDK
Import `DeepSeekSDK` in your Swift file:
```swift
import DeepSeekSDK
```

### 2. Initialize the Client
Create an instance of `DeepSeekClient` with your API key:
```swift
let apiKey = "your_api_key_here" // Replace with your actual API key
let client = DeepSeekClient(apiKey: apiKey)
```

### 3. Send a Prompt
Use the `sendPrompt` method to send a prompt and receive a response:
```swift
client.sendPrompt("What is the capital of France?") { result in
    switch result {
    case .success(let response):
        print("Response: \(response)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}
```

## API Reference

### `DeepSeekClient`
The main class for interacting with the DeepSeek API.

#### Initialization
```swift
init(apiKey: String)
```
- `apiKey`: Your DeepSeek API key.

#### Methods
```swift
func sendPrompt(_ prompt: String, completion: @escaping (Result<String, Error>) -> Void)
```
- `prompt`: The user's input prompt.
- `completion`: A closure that returns a `Result` with the response or an error.

## Error Handling
The SDK uses Swift's `Result` type to handle success and failure cases. Possible errors include:
- **Network errors**: Issues with the network connection.
- **Invalid API key**: The provided API key is invalid.
- **Invalid response**: The API returned an unexpected response.

## Example Project
Example project is not included currently implemnation tested using unit test. 

## Contributing
I welcome contributions to `DeepSeekSDK`! If you'd like to contribute, please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a detailed description of your changes.

## Support
If you encounter any issues or have questions, please:
- Open an issue on [GitHub](https://github.com/sarathdev/DeepSeekSDK/issues).

## Contact
- Contact me at [sskumbalath@gmail.com](mailto:sskumbalath@gmail.com).
- Linked In: https://www.linkedin.com/in/sarath-sasi-ios/
- Stack Overflow: https://stackoverflow.com/users/4264233/sarath-sasi

## Acknowledgments
- Thanks to the DeepSeek team for providing the API.
- Special thanks to all contributors and users of the SDK.
