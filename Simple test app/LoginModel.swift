//
//  LoginModel.swift
//  Simple test app
//
//  Created by Yemi Pedro on 06/10/20.
//

// To parse the JSON, add this file to your project and do:
//
//   let loginModel = try? newJSONDecoder().decode(LoginModel.self, from: jsonData)

//
// To read values from URLs:
//
//   let task = URLSession.shared.loginModelTask(with: url) { loginModel, response, error in
//     if let loginModel = loginModel {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let sucess: Bool
    let token: String?
    let message: String?
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URLRequest, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func loginModelTask(with url: URLRequest, completionHandler: @escaping (LoginModel?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

