//
//  ListController.swift
//  Pair
//
//  Created by Ryan Plitt on 8/26/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import Foundation
import CoreData
import GameplayKit

class ListController {

    static let sharedController = ListController()
    
    init(){
        let request = NSFetchRequest(entityName: "Person")
        let sortDescriptor = NSSortDescriptor(key: "groupNumber", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        let moc = Stack.sharedStack.managedObjectContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "groupNumber", cacheName: nil)
        
        _ = try? fetchedResultsController.performFetch()
    }
    
    let fetchedResultsController: NSFetchedResultsController
    
    func addPerson(name: String, groupNumber: Int = 0){
        _ = Person(name: name, groupNumber: groupNumber)
        saveToPersistentStore()
    }

    func deletePerson(person: Person){
        person.managedObjectContext?.deleteObject(person)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore(){
        do{
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Saving Error")
        }
    }
    
    func randomizeIntoGroups(){
        guard let arrayOfPeople = fetchedResultsController.fetchedObjects as? [Person] else {return}
        guard let randomArray = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(arrayOfPeople) as? [Person] else {
            print("There was a problem with the random")
            return
        }
        var groupsCount: Int = 0
        var groupCount: Int = 0
        for person in randomArray {
            if groupCount > 1 {
                groupsCount += 1
                groupCount = 0
            }
            if groupCount <= 1 {
                person.groupNumber = groupsCount
                groupCount += 1
            }
        }
        saveToPersistentStore()
    }
}