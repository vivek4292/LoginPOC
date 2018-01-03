//
//  Base+CoreDataProperties.swift
//  LoginPOC
//
//  Created by Rigil on 02/01/18.
//  Copyright © 2018 E-SaarTechy. All rights reserved.
//
//

import Foundation
import CoreData


extension Base {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Base> {
        return NSFetchRequest<Base>(entityName: "Base")
    }

    // Attributes
    @NSManaged public var desc: String?
    @NSManaged public var name: String?
    @NSManaged public var identifier: String?
    @NSManaged public var role: String?
    @NSManaged public var baseTables: NSObject?
    
    // Relationship
    @NSManaged public var tables: NSOrderedSet?

}

// MARK: Generated accessors for baseTables
extension Base {

    @objc(insertObject:inBaseTablesAtIndex:)
    @NSManaged public func insertIntoBaseTables(_ value: Table, at idx: Int)

    @objc(removeObjectFromBaseTablesAtIndex:)
    @NSManaged public func removeFromBaseTables(at idx: Int)

    @objc(insertBaseTables:atIndexes:)
    @NSManaged public func insertIntoBaseTables(_ values: [Table], at indexes: NSIndexSet)

    @objc(removeBaseTablesAtIndexes:)
    @NSManaged public func removeFromBaseTables(at indexes: NSIndexSet)

    @objc(replaceObjectInBaseTablesAtIndex:withObject:)
    @NSManaged public func replaceBaseTables(at idx: Int, with value: Table)

    @objc(replaceBaseTablesAtIndexes:withBaseTables:)
    @NSManaged public func replaceBaseTables(at indexes: NSIndexSet, with values: [Table])

    @objc(addBaseTablesObject:)
    @NSManaged public func addToBaseTables(_ value: Table)

    @objc(removeBaseTablesObject:)
    @NSManaged public func removeFromBaseTables(_ value: Table)

    @objc(addBaseTables:)
    @NSManaged public func addToBaseTables(_ values: NSOrderedSet)

    @objc(removeBaseTables:)
    @NSManaged public func removeFromBaseTables(_ values: NSOrderedSet)

}
