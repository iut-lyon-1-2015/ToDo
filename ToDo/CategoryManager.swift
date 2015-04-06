//
//  CategoryManager.swift
//  ToDo
//
//  Created by William Antwi on 06/04/2015.
//  Copyright (c) 2015 William Antwi. All rights reserved.
//

import Foundation

import CoreData

class CategoryManager {
    
    var coreDataManager: CoreDataManager?
    
    init (coreDataManager: CoreDataManager) {
        
        self.coreDataManager = coreDataManager
    }
    
    func createCategoryWithName(name : String?) -> Category? {
        
        if let nameValue = name {
            
            if coreDataManager != nil {
                
                let entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: coreDataManager!.managedObjectContext)
                
                let category = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataManager!.managedObjectContext) as Category
                
                category.name = nameValue
                
                var error: NSError? = nil
                
                coreDataManager!.managedObjectContext.save(&error)
                
                if error != nil {
                    println("Could not save context : \(error), \(error?.description)")
                }
                
                return category
                
            }
        }
        
        return nil
    }
    
    func deleteCategory(category: Category?) {
        
        if let categoryToDelete = category {
            coreDataManager!.managedObjectContext.deleteObject(categoryToDelete)
            coreDataManager!.managedObjectContext.save(nil)
        }
    }
    
    func fetchCategories() -> [Category]? {
        
        if let core = coreDataManager {
            
            let fetchRequest = NSFetchRequest(entityName: "Category")
            
            var error: NSError? = nil
            
            if let results = core.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [Category] {
                
                return results
            }
            
            if error != nil {
                println("Could not fetch data : \(error), \(error?.description)")
            }
            
        }
        
        return nil
        
    }
}