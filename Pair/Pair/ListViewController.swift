//
//  ListViewController.swift
//  Pair
//
//  Created by Ryan Plitt on 8/26/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        ListController.sharedController.fetchedResultsController.delegate = self
    }

    
    @IBAction func addNewNameButtonTapped(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Person", message: "Add a person to your list", preferredStyle: .Alert)
        var itemNameTextField: UITextField?
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Person Name"
            itemNameTextField = textField
        }
        
        let dismiss = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let addPerson = UIAlertAction(title: "Add Person", style: .Default) { (_) in
            guard let placeText = itemNameTextField?.text else {return}
            ListController.sharedController.addPerson(placeText)
        }
        
        alert.addAction(dismiss)
        alert.addAction(addPerson)
        
        presentViewController(alert, animated: true, completion: nil)

    }
    
    @IBAction func clearAllButtonTapped(sender: AnyObject) {
        guard let objects = ListController.sharedController.fetchedResultsController.fetchedObjects as? [Person] else {
            print("The clear failed")
            return
        }
        for person in objects {
            ListController.sharedController.deletePerson(person)
        }
        _ = ListController.sharedController.saveToPersistentStore()
    }
    
    @IBAction func randomizeButtonTapped(sender: UIButton) {
        ListController.sharedController.randomizeIntoGroups()
    }

    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return ListController.sharedController.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        guard let sections = ListController.sharedController.fetchedResultsController.sections else {return 0}
        
        return sections[section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("personCell", forIndexPath: indexPath)
        let person = ListController.sharedController.fetchedResultsController.objectAtIndexPath(indexPath) as? Person
        cell.textLabel?.text = person?.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            guard let person = ListController.sharedController.fetchedResultsController.objectAtIndexPath(indexPath) as? Person else {return}
            ListController.sharedController.deletePerson(person)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = ListController.sharedController.fetchedResultsController.sections,
            index = Int(sections[section].name) else {return nil}
        let title: String = "Group \(index + 1)"
        return title
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Delete: tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Insert: tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default: break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert: guard let newIndexPath = newIndexPath else {return}
        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        case .Delete: guard let indexPath = indexPath else {return}
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        case .Update: guard let indexPath = indexPath else {return}
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        case .Move: guard let indexPath = indexPath, newIndexPath = newIndexPath else {return}
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
