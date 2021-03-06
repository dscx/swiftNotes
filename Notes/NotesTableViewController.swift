//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Dan on 4/16/15.
//  Copyright (c) 2015 dscx. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController, AddNoteViewControllerDelegate {
    
    var notes:NSArray
    var session:NSURLSession
    
    required init(coder aDecoder: NSCoder) {
//        notes = ["Sample Note 1",  "Sample Note 2", "Sample Note 3"]
        notes = []
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadNotes()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("noteCell")
            as! UITableViewCell
    
        cell.textLabel!.text = notes[indexPath.row] as? String
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "ShowAddNote"){
            let addNoteViewController = segue.destinationViewController as? AddNoteViewController
            addNoteViewController?.delegate = self
        }
    }
    
    func saveNote(controller: AddNoteViewController, noteText: String) {
        println("Text from view controller: \(noteText)")
        
        var mutableNotes:NSMutableArray = NSMutableArray(array: notes)
            mutableNotes.addObject(noteText)
            notes = NSArray(array: mutableNotes)
        tableView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func loadNotes() -> Void {
        let requestUrl = NSMutableURLRequest(URL: NSURL(string:"http://localhost:8080/notes")!)
        let getNotesTask = session.dataTaskWithRequest(requestUrl, completionHandler: { (responseData, response, error) -> Void in
            var readJSONError:NSError?
            let noteTextJSONData = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments, error:&readJSONError) as! NSArray
            
            if let err = readJSONError {
                println(err.localizedDescription)
            } else {
             let mutableArray = NSMutableArray()
                for note in noteTextJSONData {
                    mutableArray.addObject(note["name"] as! NSString)
                }
                self.notes = mutableArray.copy() as! NSArray
            }
            self.tableView.reloadData()
        })
        getNotesTask.resume()
    }
}
