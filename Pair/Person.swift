//
//  Person.swift
//  Pair
//
//  Created by Ryan Plitt on 8/26/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import Foundation
import CoreData



class Person: NSManagedObject {

    convenience init?(name: String, groupNumber: Int?, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext){
        
        guard let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: context) else {return nil}
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
        self.groupNumber = groupNumber
    }

}
