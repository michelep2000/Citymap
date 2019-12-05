//
//  User+CoreDataProperties.swift
//  
//
//  Created by Michele Alfonso Pardo Pezzullo on 5/12/19.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var surname: String?

}
