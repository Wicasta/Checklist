//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Wicasta Lovelace on 9/2/21.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
  var dataModel: DataModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Enable large titles
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    navigationController?.delegate = self
    
    let index = dataModel.indexOfSelectedChecklist
    if index >= 0 && index < dataModel.lists.count {
      let checklist = dataModel.lists[index]
      performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK:- Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowChecklist" {
      let controller = segue.destination as! ChecklistViewController
      controller.checklist = sender as! Checklist
    } else if segue.identifier == "AddChecklist" {
      let controller = segue.destination as! ListDetailViewController
      controller.delegate = self
    }
  }
  
  // MARK:- Private Methods
  func makeCell(for tableView: UITableView) -> UITableViewCell {
    let cellIdentifier = "Cell"
    if let cell =
      tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
      return cell
    } else {
      return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
    }
  }
  
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataModel.lists.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = makeCell(for: tableView)
    // Update cell informaiton
    let checklist = dataModel.lists[indexPath.row]
    cell.textLabel!.text = checklist.name
    cell.accessoryType = .detailDisclosureButton
    let count = checklist.countUncheckedItems()
    if checklist.items.count == 0 {
      cell.detailTextLabel!.text = "(No Items)"
    } else if count == 0 {
      cell.detailTextLabel!.text = "All Done!"
    } else {
      cell.detailTextLabel!.text = "\(count) Remaining"
    }
    cell.imageView!.image = UIImage(named: checklist.iconName)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    dataModel.indexOfSelectedChecklist = indexPath.row
    let checklist = dataModel.lists[indexPath.row]
    performSegue(withIdentifier: "ShowChecklist", sender: checklist)
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    dataModel.lists.remove(at: indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }
  
  override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    
    let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
    controller.delegate = self
    
    let checklist = dataModel.lists[indexPath.row]
    controller.checklistToEdit = checklist
    navigationController?.pushViewController(controller, animated: true)
  }
  
  // MARK:- List Detail View Controller Delegates
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
    dataModel.lists.append(checklist)
    dataModel.sortChecklists()
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
    dataModel.sortChecklists()
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
  
  // MARK:- UINavigationController Delegate
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    // Was the back button tapped?
    if viewController === self {
      dataModel.indexOfSelectedChecklist = -1
    }
  }
}
