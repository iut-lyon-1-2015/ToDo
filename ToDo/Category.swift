//
//  Category.swift
//  ToDo
//
//  Created by William Antwi on 08/04/2015.
//  Copyright (c) 2015 William Antwi. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var tasks: NSSet

}
