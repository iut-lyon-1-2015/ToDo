//
//  ViewController.swift
//  ToDo
//
//  Created by William Antwi on 01/04/2015.
//  Copyright (c) 2015 William Antwi. All rights reserved.
//

import CoreData
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var tasks = [NSManagedObject]()
    
    @IBAction func addTask(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "ToDo",
            message: "Add task",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default)
            { (_) -> Void in
                
                let textField = alert.textFields![0] as UITextField
                
                if let task = self.createTaskForName(textField.text) {
                 
                    self.tasks.append(task)
                    
                    self.tableView.reloadData()
                }

                
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addTextFieldWithConfigurationHandler(nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.loadData()
    }
    
    //MARK: Persistence
    func createTaskForName(name : String?) -> NSManagedObject? {
        
        if let nameValue = name {
            
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            
            let managedObjectContext = appDelegate.managedObjectContext!
            
            let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)
            
            let task = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            
            task.setValue(nameValue, forKey: "name")
            
            var error: NSError? = nil
            
            task.managedObjectContext?.save(&error)
            
            if error != nil {
                println("Could not save context : \(error), \(error?.description)")
            }
            
            return task
        }
        
        return nil
    }
    
    func loadData() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedObjectContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Task")
        
        var error: NSError? = nil
        
        if let results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject] {
            
            tasks = results
        }
        
        if error != nil {
            println("Could not fetch data : \(error), \(error?.description)")
        }
        
    }
    
    //MARK: UITableViewDelegate & UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        let task = self.tasks[indexPath.row]
        
        cell.textLabel?.text = task.valueForKey("name") as? String
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}

