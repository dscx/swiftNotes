//
//  AddNoteViewController.swift
//  Notes
//
//  Created by Dan on 4/16/15.
//  Copyright (c) 2015 dscx. All rights reserved.
//

import UIKit

protocol AddNoteViewControllerDelegate {
    func saveNote(controller: AddNoteViewController, noteText: String)
}

class AddNoteViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var ourTextField:UITextField?
    
    var delegate: AddNoteViewControllerDelegate?
    
    @IBAction func closeAddNote(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

//        println("Text Value Entered is: \(textField.text) ")
        
        delegate?.saveNote(self, noteText: textField.text)
        
        return true
    }

}
