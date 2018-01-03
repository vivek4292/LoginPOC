//
//  Base+CoreDataClass.swift
//  LoginPOC
//
//  Created by Rigil on 02/01/18.
//  Copyright © 2018 E-SaarTechy. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON


public class Base: NSManagedObject {
    
    class func create(json: JSON) -> Base {
        //Create a new object of the Entity, insert it and set it's attribute
        let managedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
        let base = NSEntityDescription.insertNewObject(forEntityName: "Base", into: managedObjectContext) as! Base
        base.update(json: json)
        return base
    }
    
    class func all() -> [Base]?{
        var objects: [Base]?
        do{
            let fetchedObjects = try
                (CoreDataManager.shared.persistentContainer.viewContext.fetch(self.fetchRequest())) as! [Base]
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
        self.role = json["role"].stringValue
    }
}
