//
//  Task.swift
//  Task
//
//  Created by William Antwi on 08/04/2015.
//  Copyright (c) 2015 William Antwi. All rights reserved.
//

import Foundation
import CoreData

class Task: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var name: String
    @NSManaged var photo: NSData
    @NSManaged var text: String
    @NSManaged var category: Category

}
