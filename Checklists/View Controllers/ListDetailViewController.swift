//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Wicasta Lovelace on 9/2/21.
//  Copyright © 2021 Razeware. All rights reserved.
//

import Foundation
import UIKit

protocol ListDetailViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
  func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
  func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet weak var iconImageView: UIImageView!
	
  weak var delegate: ListDetailViewControllerDelegate?
  
  var checklistToEdit: Checklist?
  var iconName = "Folder"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Disable large titles for this view controller
    navigationItem.largeTitleDisplayMode = .never
    if let checklist = checklistToEdit {
      title = "Edit Checklist"
      textField.text = checklist.name
      doneBarButton.isEnabled = true
      iconName = checklist.iconName
    }
    iconImageView.image = UIImage(named: iconName)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  // MARK:- Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PickIcon" {
      let controller = segue.destination as! IconPickerViewController
      controller.delegate = self
    }
  }
  
  // MARK:- Actions
  @IBAction func cancel() {
    delegate?.listDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let checklist = checklistToEdit {
      checklist.name = textField.text!
      checklist.iconName = iconName
      delegate?.listDetailViewController(self, didFinishEditing: checklist)
    } else {
      let checklist = Checklist(name: textField.text!, iconName: iconName)
      delegate?.listDetailViewController(self, didFinishAdding: checklist)
    }
  }
  
  // MARK:- TableView Delegates
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if indexPath.section == 1 {
      return indexPath
    } else {
      return nil
    }
  }
  
  // MARK:- UITextField Delegates
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    let oldText = textField.text!
    let stringRange = Range(range, in:oldText)!
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    doneBarButton.isEnabled = !newText.isEmpty
    return true
  }
  
  // MARK:- Icon Picker View Controller Delegate
  func iconPicker(_ picker: IconPickerViewController,
                  didPick iconName: String) {
    self.iconName = iconName
    iconImageView.image = UIImage(named: iconName)
    navigationController?.popViewController(animated: true)
  }
}
