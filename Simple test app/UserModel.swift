//
//  UserModel.swift
//  Simple test app
//
//  Created by Yemi Pedro on 07/10/20.
//

// To parse the JSON, add this file to your project and do:
//
//   let userModel = try? newJSONDecoder().decode(UserModel.self, from: jsonData)

//
// To read values from URLs:
//
//   let task = URLSession.shared.userModelTask(with: url) { userModel, response, error in
//     if let userModel = userModel {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - UserModel
struct UserModel: Codable {
    let test: Test?
    let sucess : Bool?
    let message : String?
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.testTask(with: url) { test, response, error in
//     if let test = test {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Test
struct Test: Codable {
    let data: DataClass
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.dataClassTask(with: url) { dataClass, response, error in
//     if let dataClass = dataClass {
//       ...
//     }
//   }
//   task.resume()

// MARK: - DataClass
struct DataClass: Codable {
    let profile: [Profile]
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.profileTask(with: url) { profile, response, error in
//     if let profile = profile {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Profile
struct Profile: Codable {
    let id: Int
    let userName: String
    let gender: Gender
    let displayPic: String
    let dob: String
    let aboutUser, jobTitle, company, school: String?
    let dontShowAge, makeDistanceInvisible: String
    let isUserVerified, age: Int
    let distance: Double
    let religionName: ReligionName
    let swipeType: JSONNull?
    let addStatus: String
    let profileImages: [ProfileImage]
    let hobbies: [Hobby]
    let personality: [Personality]

    enum CodingKeys: String, CodingKey {
        case id, userName, gender, displayPic, dob, aboutUser, jobTitle, company, school, dontShowAge, makeDistanceInvisible, isUserVerified, age, distance
        case religionName = "religion_name"
        case swipeType, addStatus
        case profileImages = "profile_images"
        case hobbies, personality
    }
}

enum Gender: String, Codable {
    case genderMale = "male"
    case male = "Male"
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.hobbyTask(with: url) { hobby, response, error in
//     if let hobby = hobby {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Hobby
struct Hobby: Codable {
    let id: Int
    let hobbieName: String

    enum CodingKeys: String, CodingKey {
        case id
        case hobbieName = "hobbie_name"
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.personalityTask(with: url) { personality, response, error in
//     if let personality = personality {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Personality
struct Personality: Codable {
    let id: Int
    let personalityName: String

    enum CodingKeys: String, CodingKey {
        case id
        case personalityName = "personality_name"
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.profileImageTask(with: url) { profileImage, response, error in
//     if let profileImage = profileImage {
//       ...
//     }
//   }
//   task.resume()

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let id: Int
    let userID: String
    let imageURL: String
    let createdAt, updatedAt: String
}

enum ReligionName: String, Codable {
    case christian = "Christian"
    case others = "others"
}

// MARK: - Helper functions for creating encoders and decoders

//func newJSONDecoder() -> JSONDecoder {
//    let decoder = JSONDecoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        decoder.dateDecodingStrategy = .iso8601
//    }
//    return decoder
//}

//func newJSONEncoder() -> JSONEncoder {
//    let encoder = JSONEncoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        encoder.dateEncodingStrategy = .iso8601
//    }
//    return encoder
//}

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

    func userModelTask(with url: URLRequest, completionHandler: @escaping (UserModel?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

