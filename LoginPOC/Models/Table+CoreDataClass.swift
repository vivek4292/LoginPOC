//
//  Table+CoreDataClass.swift
//  LoginPOC
//
//  Created by Rigil on 02/01/18.
//  Copyright © 2018 E-SaarTechy. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON


public class Table: NSManagedObject {
    
    class func create(json:JSON) -> Table {
        //Create a new object of the Entity, insert it and set it's attribute
        let managedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
        let table = NSEntityDescription.insertNewObject(forEntityName: "Table", into: managedObjectContext) as! Table
        table.update(json: json)
        return table
        
    }
    
    class func all() -> [Table]?{
        var objects: [Table]?
        do{
         let fetchedObjects = try
            (CoreDataManager.shared.persistentContainer.viewContext.fetch(self.fetchRequest())) as! [Table]
            if fetchedObjects.count > 0{
                objects = fetchedObjects
            }
        } catch {
            fatalError("Failed to fetch: \(error)")
        }
        return objects
    }

    public func update(json:JSON) {
        self.identifier = json["id"].stringValue
        self.name = json["name"].stringValue
        self.desc = json["description"].stringValue
    }
}
