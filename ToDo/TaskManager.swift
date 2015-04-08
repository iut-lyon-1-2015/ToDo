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
    
    func fetchTask(predicate: NSPredicate) -> Task? {
        
        if let tasks = fetchTasks(predicate, sortDescriptors: nil) {
            return tasks[0]
        }
        
        return nil
    }
    
    func fetchTasks(predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]?) -> [Task]? {
        
        let fetchRequest = NSFetchRequest(entityName: "Task")

        fetchRequest.sortDescriptors = sortDescriptors

        fetchRequest.predicate = predicate
        
        if coreDataManager != nil {
            
            var error: NSError? = nil
            
            let results = coreDataManager?.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as [Task]
            
            if results.count > 0 {
                return results
            }
        }
        
        return nil
    }
    
    func searchTaskWithName(name: String?) -> Task? {
        
        
        if name != nil {
            
            let predicate = NSPredicate(format: "name = %@", name!)!
            
            return fetchTask(predicate)
        }
        
        
        return nil
    }
    
    func deleteTask(task: Task?) {
        
        if let taskToDelete = task {
            coreDataManager!.managedObjectContext.deleteObject(taskToDelete)
            coreDataManager!.managedObjectContext.save(nil)
        }
    }
    
    func fetchTasks() -> [Task]? {
        
        if let core = coreDataManager {
            
            let fetchRequest = NSFetchRequest(entityName: "Task")
            
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
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
    
    func numberOfTasks() -> NSInteger {
        
        var count = 0

        if let core = coreDataManager {
            
            let fetchRequest = NSFetchRequest(entityName: "Task")
            
            fetchRequest.resultType = NSFetchRequestResultType.CountResultType
            
            var error: NSError? = nil
            
            if let result = core.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [NSNumber] {
                
                return result[0].integerValue
            }
            
            //or
            count = core.managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
            
            if error != nil {
                println("Could not fetch data : \(error), \(error?.description)")
            }
        }
        
        return count
    }
    
}