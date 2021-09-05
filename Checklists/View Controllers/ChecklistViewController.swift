

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
  var checklist: Checklist!

  //  required init?(coder aDecoder: NSCoder) {
  //    checklist.items = [ChecklistItem]()
      
  //    let row0item = ChecklistItem()
  //    row0item.text = "Walk the dog"
  //    row0item.checked = false
  //    checklist.items.append(row0item)
  //
  //    let row1item = ChecklistItem()
  //    row1item.text = "Brush my teeth"
  //    row1item.checked = true
  //    checklist.items.append(row1item)
  //
  //    let row2item = ChecklistItem()
  //    row2item.text = "Learn iOS development"
  //    row2item.checked = true
  //    checklist.items.append(row2item)
  //
  //    let row3item = ChecklistItem()
  //    row3item.text = "Soccer practice"
  //    row3item.checked = false
  //    checklist.items.append(row3item)
  //
  //    let row4item = ChecklistItem()
  //    row4item.text = "Eat ice cream"
  //    row4item.checked = true
  //    checklist.items.append(row4item)
      
  //    super.init(coder: aDecoder)
  //  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Disable large titles for this view controller
    navigationItem.largeTitleDisplayMode = .never
    
    
    // COMMENTED OUT AND LEFT JUST IN CASE - REMOVE LATER
    // items.append(item5) ???
    // print("Documents folder is \(documentsDirectory())")
    // print("Data file path is \(dataFilePath())")
    
    // Load items
    
    title = checklist.name
  }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
  
  // MARK:- Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddItem" {
      let controller = segue.destination as! ItemDetailViewController
      controller.delegate = self
    } else if segue.identifier == "EditItem" {
      let controller = segue.destination as! ItemDetailViewController
      controller.delegate = self
      if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
        controller.itemToEdit = checklist.items[indexPath.row]
      }
    }
  }
  
  // MARK:- Actions
  
  // MARK:- Private Methods
  func configureCheckmark(for cell: UITableViewCell,
                          with item: ChecklistItem) {
    let label = cell.viewWithTag(1001) as! UILabel
    label.textColor = view.tintColor
    if item.checked {
      label.text = "√"
    } else {
      label.text = ""
    }
  }
  
  func configureText(for cell: UITableViewCell,
                     with item: ChecklistItem) {
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
//    label.text = "\(item.itemID): \(item.text)"
  }
    
  // MARK:- TableView Delegates
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return checklist.items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "ChecklistItem", for: indexPath)
    let item = checklist.items[indexPath.row]
    configureText(for: cell, with: item)
    configureCheckmark(for: cell, with: item)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      let item = checklist.items[indexPath.row]
      item.toggleChecked()
      configureCheckmark(for: cell, with: item)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    checklist.items.remove(at: indexPath.row)
    
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }
  
  // MARK:- AddItemViewController Delegates
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
    navigationController?.popViewController(animated:true)
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
    let newRowIndex = checklist.items.count
    checklist.items.append(item)
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
    navigationController?.popViewController(animated:true)
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
    if let index = checklist.items.index(of: item) {
      let indexPath = IndexPath(row: index, section: 0)
      if let cell = tableView.cellForRow(at: indexPath) {
        configureText(for: cell, with: item)
      }
    }
    navigationController?.popViewController(animated:true)
  }
}

