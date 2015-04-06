//
//  CategoriesViewController.swift
//  ToDo
//
//  Created by William Antwi on 06/04/2015.
//  Copyright (c) 2015 William Antwi. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories = [Category]()
    
    var categoryManager = CategoryManager(coreDataManager: CoreDataManager.sharedManager)
    
    var selectedCategory: Category? = nil
    
    var selectedIndexPath: NSIndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        loadData()
    }
    
    func loadData() {
        
        if let results = categoryManager.fetchCategories() {
            
            self.categories = results;
        }
        
        self.tableView.reloadData()
    }

    @IBAction func save(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func addCategory(sender: AnyObject) {
        
        let alert = UIAlertController(title: "ToDo",
            message: "Add category",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default)
            { (_) -> Void in
                
                let textField = alert.textFields![0] as UITextField
                
                if let category = self.categoryManager.createCategoryWithName(textField.text) {
                    
                    self.categories.insert(category, atIndex: 0)
                    
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation:UITableViewRowAnimation.Top)
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
    
    //MARK: UITableViewDelegate & UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        let category = self.categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let category = self.categories[indexPath.row]
        
        self.categories.removeAtIndex(indexPath.row)
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        categoryManager.deleteCategory(category)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let previousIndexPath: NSIndexPath = selectedIndexPath {
            
            let cell = tableView.cellForRowAtIndexPath(previousIndexPath)
            
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        selectedCategory = self.categories[indexPath.row]
        
        selectedIndexPath = indexPath
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
