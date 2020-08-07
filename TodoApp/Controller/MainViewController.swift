//
//  MainViewController.swift
//  TodoApp
//
//  Created by Trần Huy on 7/31/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import CoreData

let reuseIdentifier = "reuseIdentifier"
class MainViewController: UITableViewController {
    //MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    let searchBar = UISearchBar(frame: .zero)
    var filterListApp = [ItemCD]()
    var itemArray = [ItemCD]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        
        
        let request: NSFetchRequest<ItemCD> = ItemCD.fetchRequest()

       loadItems(with: request)
        
        
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
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        

        return cell
    }
    
    //MARK: - Selector
    @objc func addTask() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default, handler: {(action) in
            if textField.hasText {
                
                let newItem = ItemCD(context: self.context)
                
                
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                self.saveItems()
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
    
    func saveItems() {
        
        if context.hasChanges {
        do {
            try context.save()
            
            print("have save")

        } catch {
            print("Error endcoding item array")
        }
        
        self.tableView.reloadData()
        }
    }
    
    func loadItems(with request: NSFetchRequest<ItemCD> = ItemCD.fetchRequest(), predicate: NSPredicate? = nil) {
        //Encode Decode
//        do {
//            if let data = try? Data(contentsOf: dataFilePath!) {
//                let decoder = PropertyListDecoder()
//                itemArray = try decoder.decode([Item].self, from: data)
//            }
//
//        } catch {
//
//        }
        
        //Core Data
        
//        let request: NSFetchRequest<ItemCD> = ItemCD.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray = try context.fetch(request)

        } catch {
            print("\(error)")
        }
        tableView.reloadData()
        
    }
    

    

}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<ItemCD> = ItemCD.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
        
        let sortDescpriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescpriptor]
        
        loadItems(with: request, predicate: predicate)
        
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error with \(error)")
//        }
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            searchBar.resignFirstResponder()

            DispatchQueue.main.async {

            }
        }
    }
    
    
}
