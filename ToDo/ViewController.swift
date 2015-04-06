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

    var tasks = [Task]()
    
    var taskManager = TaskManager(coreDataManager: CoreDataManager.sharedManager)
    
    @IBAction func addTask(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "ToDo",
            message: "Add task",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default)
            { (_) -> Void in
                
                let textField = alert.textFields![0] as UITextField
                
                if let task = self.taskManager.createTaskForName(textField.text) {
                 
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
        
        if let results = taskManager.fetchTasks() {
            
            self.tasks = results;
        }
        
    }
    
    
    //MARK: UITableViewDelegate & UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        let task = self.tasks[indexPath.row]
        
        cell.textLabel?.text = task.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let task = self.tasks[indexPath.row]
        
        self.tasks.removeAtIndex(indexPath.row)
        
        task.managedObjectContext?.deleteObject(task)
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        task.managedObjectContext?.save(nil)
    }
    

}

