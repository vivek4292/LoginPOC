//
//  Row+CoreDataProperties.swift
//  LoginPOC
//
//  Created by Rigil on 02/01/18.
//  Copyright © 2018 E-SaarTechy. All rights reserved.
//
//

import Foundation
import CoreData


extension Row {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Row> {
        return NSFetchRequest<Row>(entityName: "Row")
    }

    @NSManaged public var createdTime: NSDate?
    @NSManaged public var rowId: String?
    @NSManaged public var rowsTable: Table?

}
