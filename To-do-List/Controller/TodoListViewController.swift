//
//  TodoListViewController.swift
//  To-do-List
//
//  Created by Nguyen Tran on 7/30/22.
//

import UIKit

class TodoListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sampleItemTest.append(item1)
        sampleItemTest.append(item2)
        sampleItemTest.append(item3)
    }
    
//    var sampleTestItem = ["shopping", "being cool", "gym"]
    
    var item1 = Item(text: "shopping", isDone: false)
    var item2 = Item(text: "cool", isDone: false)
    var item3 = Item(text: "gym", isDone: false)
    var sampleItemTest = [Item]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addBarButtonDidTap(_ sender: UIBarButtonItem) {
        let addingItemAlert = UIAlertController(title: "Adding New Item", message: nil, preferredStyle: .alert)
        
        let addButton = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
            guard let textFields = addingItemAlert.textFields
            else {
                return
            }
            
            let itemTextField = textFields[0] as UITextField
            guard let itemText = itemTextField.text, itemText != ""
            else {
                return
            }
            let newItem = Item(text: itemText, isDone: false)
            self.sampleItemTest.append(newItem)
            self.tableView.reloadData()
            
            
         })
        addingItemAlert.addTextField { textField in
            textField.placeholder = "Enter new item"
            
        }
        addingItemAlert.addAction(addButton)
        self.present(addingItemAlert, animated: true, completion: nil)
    }
}


extension TodoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleItemTest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel!.text = sampleItemTest[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath)
        else {
            return
        }
        
        sampleItemTest[indexPath.row].isDone ? (cell.accessoryType = .none) : (cell.accessoryType = .checkmark)
        sampleItemTest[indexPath.row].isDone = !sampleItemTest[indexPath.row].isDone
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            sampleItemTest.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

