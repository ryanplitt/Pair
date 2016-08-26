//
//  ListController.swift
//  Pair
//
//  Created by Ryan Plitt on 8/26/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import Foundation
import CoreData

class ListController {

    static let sharedController = ListController()
    
    init(){
        let request = NSFetchRequest(entityName: "Person")
        let sortDescriptor = NSSortDescriptor(key: "groupNumber", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        let moc = Stack.sharedStack.managedObjectContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "groupNumber", cacheName: nil)
    }
    
    
    var List: [AnyObject] = []
    
    let fetchedResultsController: NSFetchedResultsController
    
    func addPerson(name: String){
        _ = Person(name: name, groupNumber: nil)
        saveToPersistentStore()
    }

    func deletePerson(person: Person){
        person.managedObjectContext?.deleteObject(person)
    }
    
    func saveToPersistentStore(){
        do{
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Saving Error")
        }
    }
    
    
    
    
}