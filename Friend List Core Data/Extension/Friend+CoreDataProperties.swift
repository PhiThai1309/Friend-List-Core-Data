//
//  Friend+CoreDataProperties.swift
//  Friend List Core Data
//
//  Created by phi.thai on 3/14/23.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var id: Double
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var gender: String?
    @NSManaged public var status: String?

}

extension Friend : Identifiable {

}
