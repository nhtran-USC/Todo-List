//
//  TodoListViewController.swift
//  To-do-List
//
//  Created by Nguyen Tran on 7/30/22.
//

import UIKit
import CoreData

class TodoListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        fetchItem()
        tableView.reloadData()
    }
    
    var context: NSManagedObjectContext!
    var items:[Item]?
    
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
            let newItem = Item(context: self.context)
            newItem.text = itemText
            newItem.isDone = false
            
            self.saveItem()
            self.fetchItem()
            self.tableView.reloadData()
         })
        addingItemAlert.addTextField { textField in
            textField.placeholder = "Enter new item"
            
        }
        addingItemAlert.addAction(addButton)
        self.present(addingItemAlert, animated: true, completion: nil)
    }
    
    func saveItem() {
        do {
            try context.save()
        }
        catch {
            fatalError("Failed to save")
        }
    }
    
    func fetchItem() {
        items = try! context.fetch(Item.fetchRequest())
    }
}


extension TodoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = items
        else{
            return 0
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel!.text = items![indexPath.row].text
        items![indexPath.row].isDone ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath)
        else {
            return
        }
        
        items![indexPath.row].isDone ? (cell.accessoryType = .none) : (cell.accessoryType = .checkmark)
        items![indexPath.row].isDone = !items![indexPath.row].isDone
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
//            items!.remove(at: indexPath.row)
            context.delete(items![indexPath.row])
            saveItem()
            fetchItem()
            tableView.reloadData()
        }
    }
}

