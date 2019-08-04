//
//  ViewController.swift
//  todoey
//
//  Created by arjun adappa on 30/07/19.
//  Copyright © 2019 arjun adappa. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class ToDoListViewController: SwipeTableViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
           loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
        // Do any additional setup after loading the view.
        
        tableView.separatorStyle = .none
        
        
            
        }
        
        
        
    
    override func viewWillAppear(_ animated: Bool) {
        if let colourHex = selectedCategory?.colour{
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else {fatalError("navigation controller does not exist")}
            
            if let navBarColour = UIColor(hexString: colourHex){
                navBar.barTintColor = navBarColour
                
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
                
                searchBar.barTintColor = navBarColour
                
            }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColour = UIColor(hexString: "1D9BF6") else  {fatalError()}
        navigationController?.navigationBar.barTintColor = originalColour
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: FlatWhite()]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.colour)!.darken(byPercentage:
                CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
                
            
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
            cell.textLabel?.text = "No items added"
        }
        
        
        
        
        
        return cell
        
    }
    //table view delegate methods
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("error saving done status\(error)")
            }
        }
        tableView.reloadData()
//        print(todoItems[indexPath.row])
//        if todoItems[indexPath.row].done == false{
//            todoItems[indexPath.row].done = true
//        }
//        else{
//            todoItems[indexPath.row].done = false
//        }
//        saveItems()
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    //add items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            //what hapens after user clicks add item
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                        
                    }
                }catch{
                    print("error saving new items\(error)")
                }
                    
                
            }
            self.tableView.reloadData()
            
            
//            newItem.done = false
            
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems( ){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                print("error updating \(error)")
            }
        }
    }

    
    
}
extension ToDoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
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

