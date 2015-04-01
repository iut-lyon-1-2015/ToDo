//
//  TaskManager.swift
//  ToDo
//
//  Created by William Antwi on 01/04/2015.
//  Copyright (c) 2015 William Antwi. All rights reserved.
//

import Foundation

import CoreData


class TaskManager: DataManager {
    
    override class var sharedManager: TaskManager {
        
        struct Singleton {
            static let instance = TaskManager()
        }
        
        return Singleton.instance
    }
    
    func createTaskForName(name : String?) -> Task? {
        
        if let nameValue = name {
            
            let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)
            
            let task = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext) as Task
            
            task.name = nameValue
            
            var error: NSError? = nil
            
            managedObjectContext.save(&error)
            
            if error != nil {
                println("Could not save context : \(error), \(error?.description)")
            }
            
            return task
        }
        
        return nil
    }
    
    func fetchTasks() -> [Task]? {
        
        let fetchRequest = NSFetchRequest(entityName: "Task")
        
        var error: NSError? = nil
        
        if let results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [Task] {
            
            return results
        }
        
        if error != nil {
            println("Could not fetch data : \(error), \(error?.description)")
        }
        
        return nil
        
    }
    
}