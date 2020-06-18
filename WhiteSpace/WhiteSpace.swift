//
//  WhiteSpace.swift
//  WhiteSpace
//

import Foundation

extension String {
    /**
     Split each characters into `[String]`
     
     - Returns: All characters from `self` as a `[String]`
     */
    func split() -> [String] {
        return self.map { String($0) }
    }
}

enum WhiteSpaceCharacter: String, Codable {
    /// Normal ASCII whitespace
    case normalWhiteSpace = " "
    
    /// Full-width whitespace frequently used in CJK environment
    case fullWidthWhiteSpace = "\u{3000}"
}

struct WhiteSpaceSetting: Codable {
    var character: WhiteSpaceCharacter
    var count = 1
    
    /**
     Store given `WhiteSpaceSetting` object into `UserDefaults`
     
     In order to share the setting between main app and the keyboard extension, we have to enable App Group and use `UserDefaults(suiteName:)` to get the storage object.
     We cannot use `UserDefaults.standard`.
     
     - Parameter setting: The `WhiteSpaceSetting` being stored
     */
    static func storeToUserDefaults(_ setting: WhiteSpaceSetting) {
        let encoder = JSONEncoder()
        let json = try! encoder.encode(setting)
        
        UserDefaults(suiteName: "group.wangtongjie.WhiteSpace")?.set(json, forKey: String(describing: WhiteSpaceSetting.self))
    }
    
    /**
     Retrive the `WhiteSpaceSetting` object from `UserDefaults`; if there is no `WhiteSpaceSetting`, return a new object with default value
     
     In order to share the setting between main app and the keyboard extension, we have to enable App Group and use `UserDefaults(suiteName:)` to get the storage object.
     We cannot use `UserDefaults.standard`.
     
     - Returns: `WhiteSpaceSetting` stored in `UserDefaults`; if there is no `WhiteSpaceSetting`, a new object will be returned
     */
    static func getFromUserDefaults() -> WhiteSpaceSetting {
        guard let jsonData = UserDefaults(suiteName: "group.wangtongjie.WhiteSpace")?.object(forKey: String(describing: WhiteSpaceSetting.self)) as? Data else {
            return WhiteSpaceSetting(character: .normalWhiteSpace, count: 1)
        }
        let decoder = JSONDecoder()
        return (try? decoder.decode(
            WhiteSpaceSetting.self,
            from: jsonData
        )) ?? WhiteSpaceSetting(character: .normalWhiteSpace, count: 1)
    }
}

class WhiteSpace {
    var setting = WhiteSpaceSetting.getFromUserDefaults()
    
    /**
     Add a whitespace character between two characters in `input`, then return the new `String`
     
     - To change the whitespace character being used, modify `setting.character`
     - To change the number of whitespace characters inserted, modify `setting.count`
     
     - Parameter input: The input `String`
     
     - Returns: A new `String` that has the whitespace character inserted
     */
    func getWhiteSpacedString(from input: String) -> String {
        return input.isEmpty ? "" : input.split().joined(separator: String(repeating: setting.character.rawValue, count: setting.count))
    }
}
