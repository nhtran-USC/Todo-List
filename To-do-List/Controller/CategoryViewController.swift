//
//  CategoryViewController.swift
//  To-do-List
//
//  Created by Nguyen Tran on 8/7/22.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        loadCategory()
    }
    @IBOutlet weak var categoryTableView: UITableView!
    var categories:[CategoryTask] = []
    
    var context: NSManagedObjectContext!
    @IBAction func addBarButtonDidTap(_ sender: Any) {
        let addingItemAlert = UIAlertController(title: "Adding New Category", message: nil, preferredStyle: .alert)
        
        let addButton = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
            guard let textFields = addingItemAlert.textFields
            else {
                return
            }
            
            let categoryTextField = textFields[0] as UITextField
            guard let text = categoryTextField.text, text != ""
            else {
                return
            }
            
            let newCategory = CategoryTask(context: self.context)
            newCategory.title = text
            
            self.saveCategory()
            self.loadCategory()

         })
        addingItemAlert.addTextField { textField in
            textField.placeholder = "Enter new category"
        }
        addingItemAlert.addAction(addButton)
        self.present(addingItemAlert, animated: true, completion: nil)
    }
    
    func saveCategory() {
        do {
            try context.save()
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func loadCategory(with request: NSFetchRequest<CategoryTask> = CategoryTask.fetchRequest()) {
        do {
            categories = try context.fetch(request)
            categoryTableView.reloadData()
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
}


extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  categoryTableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel!.text = categories[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        performSegue(withIdentifier: "categoryToItemSegue", sender: selectedCategory)
        categoryTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            context.delete(categories[indexPath.row])
            saveCategory()
            loadCategory()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "categoryToItemSegue") {
            let vc = segue.destination as! TodoListViewController
            let selectedCategory  = sender as! CategoryTask
            vc.selectedCategory = selectedCategory
        }
    }
    
}
