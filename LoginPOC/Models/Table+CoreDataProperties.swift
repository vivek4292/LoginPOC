//
//  Table+CoreDataProperties.swift
//  LoginPOC
//
//  Created by Rigil on 02/01/18.
//  Copyright © 2018 E-SaarTechy. All rights reserved.
//
//

import Foundation
import CoreData


extension Table {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Table> {
        return NSFetchRequest<Table>(entityName: "Table")
    }

    // Attributes
    @NSManaged public var identifier: String?
    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var records: NSObject?
    
    
    // Relationship
    @NSManaged public var base: Base?
    @NSManaged public var rows: NSOrderedSet?

}

// MARK: Generated accessors for tableRows
extension Table {

    @objc(insertObject:inTableRowsAtIndex:)
    @NSManaged public func insertIntoTableRows(_ value: Row, at idx: Int)

    @objc(removeObjectFromTableRowsAtIndex:)
    @NSManaged public func removeFromTableRows(at idx: Int)

    @objc(insertTableRows:atIndexes:)
    @NSManaged public func insertIntoTableRows(_ values: [Row], at indexes: NSIndexSet)

    @objc(removeTableRowsAtIndexes:)
    @NSManaged public func removeFromTableRows(at indexes: NSIndexSet)

    @objc(replaceObjectInTableRowsAtIndex:withObject:)
    @NSManaged public func replaceTableRows(at idx: Int, with value: Row)

    @objc(replaceTableRowsAtIndexes:withTableRows:)
    @NSManaged public func replaceTableRows(at indexes: NSIndexSet, with values: [Row])

    @objc(addTableRowsObject:)
    @NSManaged public func addToTableRows(_ value: Row)

    @objc(removeTableRowsObject:)
    @NSManaged public func removeFromTableRows(_ value: Row)

    @objc(addTableRows:)
    @NSManaged public func addToTableRows(_ values: NSOrderedSet)

    @objc(removeTableRows:)
    @NSManaged public func removeFromTableRows(_ values: NSOrderedSet)

}
