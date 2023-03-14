//
//  Friend+CoreDataClass.swift
//  Friend List Core Data
//
//  Created by phi.thai on 3/14/23.
//
//

import Foundation
import CoreData

@objc(Friend)
public class Friend: NSManagedObject, Codable {
    
    // MARK: - Codable setUp
    enum CodingKeys: String, CodingKey {
        case gender
        case email
        case name
        case status
        case id
    }
    
    enum ManagedObjectError: Error {
        case decodeContextError
        case decodeEntityError
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context!] as? NSManagedObjectContext else {NSLog("Error: with User context!")
            throw ManagedObjectError.decodeContextError
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Friend", in: context) else {
            NSLog("Error with user enity!")
            throw ManagedObjectError.decodeEntityError
        }
        
        self.init(entity: entity, insertInto: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gender = try values.decode(String.self, forKey: .gender)
        email = try values.decode(String.self, forKey: .email)
        name = try values.decode(String.self, forKey: .name)
        status = try values.decode(String.self, forKey: .status)
        id = try values.decode(Double.self, forKey: .id)
    }
    
    // MARK: - Encoding the data
    public func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(gender, forKey: .gender)
        try container.encode(email, forKey: .email)
        try container.encode(name, forKey: .name)
        try container.encode(status, forKey: .status)
        try container.encode(id, forKey: .id)
    }
}

// This helps with decoding
extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
