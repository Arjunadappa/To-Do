//
//  ViewController.swift
//  todoey
//
//  Created by arjun adappa on 30/07/19.
//  Copyright © 2019 arjun adappa. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
        // Do any additional setup after loading the view.
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        
        
        return cell
        
    }
    //table view delegate methods
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        if itemArray[indexPath.row].done == false{
            itemArray[indexPath.row].done = true
        }
        else{
            itemArray[indexPath.row].done = false
        }
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //add items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            //what hapens after user clicks add item
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print("error saing context \(error)")
        }
        tableView.reloadData()
        
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil ){
        
        let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate,additionalPredicate])
        }
        else{
            request.predicate = categorypredicate
        }
        
        do{
         itemArray = try context.fetch(request)
            
        }
        catch{
            print("error fetching data \(error)")
        }
        tableView.reloadData()
    }
    
    
    
}
extension ToDoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let  request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request,predicate: predicate)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                
            }
            
            
        }
    }
}

