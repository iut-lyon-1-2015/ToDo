//
//  DataManager.swift
//  ToDo
//
//  Created by William Antwi on 01/04/2015.
//  Copyright (c) 2015 William Antwi. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private var _managedObjectContext: NSManagedObjectContext?
    private var _persistentStore: NSPersistentStore?
    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var _managedObjectModel: NSManagedObjectModel?
    
    class var sharedManager: CoreDataManager {
        
        struct Singleton {
            static var instance = CoreDataManager()
        }
        
        return Singleton.instance
    }
    
    init() {
        
    }
    
    var managedObjectModel: NSManagedObjectModel {
        
        get {
            if _managedObjectModel == nil {
                let modelURL = NSBundle.mainBundle().URLForResource("ToDo", withExtension: "momd")!
                _managedObjectModel =  NSManagedObjectModel(contentsOfURL: modelURL)!
            }
            
            return _managedObjectModel!
        }
        
    }
    
     var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        
        get {
            if _persistentStoreCoordinator == nil {
                _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
                
                let storeURL = applicationDocumentDirectory().URLByAppendingPathComponent("ToDo.sqlite")
                
                let options = [NSMigratePersistentStoresAutomaticallyOption : true,
                    NSInferMappingModelAutomaticallyOption: true]
                
                var error: NSError? = nil
                
                _persistentStore = _persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType,
                    configuration: nil,
                    URL: storeURL,
                    options: options,
                    error: &error)
                
                if _persistentStore == nil {
                    println("Error adding persistence store: \(error)")
                    abort()
                }
            }
            
            return _persistentStoreCoordinator!
        }
        
    }
    
    var persistentStore: NSPersistentStore {
        
        get {
            return _persistentStore!
        }
    }
    
    var managedObjectContext: NSManagedObjectContext {
        
        get {
            
            if _managedObjectContext == nil {
                
                _managedObjectContext = NSManagedObjectContext()
                _managedObjectContext!.persistentStoreCoordinator = persistentStoreCoordinator
            }
            
            return _managedObjectContext!
        }
    }
  
    func applicationDocumentDirectory() -> NSURL {
        
        let fileManager = NSFileManager.defaultManager()
        
        let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        return urls[0] as NSURL
    }
    
    
    func saveContext() {
        
        var error: NSError? = nil
        
        if managedObjectContext.hasChanges && !managedObjectContext.save(&error) {
            println("Failed to save context \(error), \(error?.userInfo)")
        }
    }
    
    func resetDatabase() {
        
        var error: NSError? = nil
        
        persistentStoreCoordinator.removePersistentStore(persistentStore, error: &error)
            
        NSFileManager.defaultManager().removeItemAtPath(persistentStore.URL!.path!, error: &error)
        
        if (error != nil) {
            println("Could not reset the database : \(error)")
        }
        
        _persistentStore = nil
        _managedObjectContext = nil
        _persistentStoreCoordinator = nil
        _managedObjectModel = nil
        
        _persistentStoreCoordinator = persistentStoreCoordinator
        _managedObjectContext = managedObjectContext
    }
}
