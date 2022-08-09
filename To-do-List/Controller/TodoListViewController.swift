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
        guard let selectedCategory = selectedCategory
        else {
            return
        }
        
        categoryRequest.predicate = NSPredicate(format: "category.title MATCHES %@", selectedCategory.title!)
        fetchItem(with: categoryRequest)
    }
    
    let categoryRequest = NSFetchRequest<Item>(entityName: "Item")
    
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var itemSearchBar: UISearchBar!
//    @IBOutlet weak var tableView: UITableView!
    
    var items:[Item]?
    var filteredItem:[Item]?
    var selectedCategory:CategoryTask!
    
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
            newItem.category = self.selectedCategory
            
            self.saveItem()
            self.fetchItem(with: self.categoryRequest)

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
    
    func fetchItem(with request:NSFetchRequest<Item> = Item.fetchRequest()) {
        items = try! context.fetch(request)
        tableView.reloadData()
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
            fetchItem(with: categoryRequest)
        }
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let itemSearchTerm = itemSearchBar.text
        else {
            return
        }
        if itemSearchTerm.isEmpty {
            fetchItem(with: categoryRequest)
            itemSearchBar.endEditing(true)
            return
        }
        
        let request = NSFetchRequest<Item>(entityName: "Item")
        
        let categoryPredicate = NSPredicate(format: "category.title MATCHES %@", selectedCategory.title!)
        let searchPredicate = NSPredicate(format: "text CONTAINS[cd] %@", itemSearchTerm)
        
        let combinePredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [searchPredicate, categoryPredicate])
        
        request.predicate = combinePredicate
        
        request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        
        fetchItem(with: request)
        itemSearchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let itemSearchTerm = itemSearchBar.text
        else {
            return
        }
        if itemSearchTerm.isEmpty {
            fetchItem(with: categoryRequest)
            return
        }
        
        let request = NSFetchRequest<Item>(entityName: "Item")
        
        let categoryPredicate = NSPredicate(format: "category.title MATCHES %@", selectedCategory.title!)
        let searchPredicate = NSPredicate(format: "text CONTAINS[cd] %@", itemSearchTerm)
        
        let combinePredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [searchPredicate, categoryPredicate])
        
        request.predicate = combinePredicate
        request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        
        fetchItem(with: request)
//        itemSearchBar.endEditing(true)
    }
    
}
