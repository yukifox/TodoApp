//
//  MainViewController.swift
//  TodoApp
//
//  Created by Trần Huy on 7/31/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

let reuseIdentifier = "reuseIdentifier"
class MainViewController: UITableViewController {
    //MARK: - Properties
    let realm = try! Realm()
    let searchController = UISearchController(searchResultsController: nil)
    let searchBar = UISearchBar(frame: .zero)
    
    var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        
        
//        let request: NSFetchRequest<ItemCD> = ItemCD.fetchRequest()
//
//       loadItems(with: request)
        
        
    }
    
    //MARK: - Init
    func setupView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableHeaderView = searchBar
        searchBar.sizeToFit()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        
        
        
        view.backgroundColor = .white
        
        configNavigationBar()
        
    }
    
    func configNavigationBar() {
        navigationItem.title = "Todoey"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .systemBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error")
            }
        }
        
//        todoItems![indexPath.row].done = !todoItems![indexPath.row].done
//        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel!.text = item.title
            
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }

        
        
        

        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = todoItems?[indexPath.row] {
                do {
                    try realm.write{
                        realm.delete(item)
                    }
                } catch {
                    print("Error")
                }
            }
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Selector
    @objc func addTask() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default, handler: {(action) in
            if textField.hasText {
                
                if let curCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            curCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error with \(error)")
                    }
                    

                }
                self.tableView.reloadData()

                
//
            }
        })
        alert.addTextField(configurationHandler: {(alerttextField) in
            alerttextField.placeholder = "Enter your task"
            textField = alerttextField
        })
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: Handler
    
//    func saveItems() {
//
//        if context.hasChanges {
//        do {
//            try context.save()
//
//            print("have save")
//
//        } catch {
//            print("Error endcoding item array")
//        }
//
//        self.tableView.reloadData()
//        }
//    }
    
    func loadItems() {
        
        //RealM
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
       
        
        //Core Data
        
//        let request: NSFetchRequest<ItemCD> = ItemCD.fetchRequest()
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let addtionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//
//        do {
//            itemArray = try context.fetch(request)
//
//        } catch {
//            print("\(error)")
//        }
        tableView.reloadData()

    }
    

    

}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }
        }
    }
    
    
}
