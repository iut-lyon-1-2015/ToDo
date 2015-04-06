//
//  TaskManager.swift
//  ToDo
//
//  Created by William Antwi on 01/04/2015.
//  Copyright (c) 2015 William Antwi. All rights reserved.
//

import Foundation

import CoreData


class TaskManager {
    
    var coreDataManager: CoreDataManager?

    init (coreDataManager: CoreDataManager) {
     
        self.coreDataManager = coreDataManager
    }
    
    func createTaskForName(name : String?) -> Task? {
        
        if let nameValue = name {
           
            if coreDataManager != nil {
                
                let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: coreDataManager!.managedObjectContext)
                
                let task = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataManager!.managedObjectContext) as Task
                
                task.name = nameValue
                
                var error: NSError? = nil
                
                coreDataManager!.managedObjectContext.save(&error)
                
                if error != nil {
                    println("Could not save context : \(error), \(error?.description)")
                }
                
                return task
                
            }
            
        }
        
        return nil
    }
    
    func fetchTasks() -> [Task]? {
        
        if let core = coreDataManager {
            
            let fetchRequest = NSFetchRequest(entityName: "Task")
            
            var error: NSError? = nil
            
            if let results = core.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [Task] {
                
                return results
            }
            
            if error != nil {
                println("Could not fetch data : \(error), \(error?.description)")
            }
            
        }
        
        return nil
        
    }
    
}