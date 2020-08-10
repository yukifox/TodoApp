//
//  MainViewController.swift
//  TodoApp
//
//  Created by Trần Huy on 8/7/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit
import ChameleonFramework


let todoCell = "todoCell"
class TodoViewController: UITableViewController {
    //MARK: - Properties
    let realm = try! Realm()
    
    let searchBar = UISearchBar(frame: .zero)
    
    var listItems: Results<Item>?
    var todoItems = [Item]()
    var doneItems = [Item]()
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
        configNavigationBar()
        
        
        
//        let request: NSFetchRequest<ItemCD> = ItemCD.fetchRequest()
//
//       loadItems(with: request)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBar()
    }
    
    //MARK: - Init
    func setupView(){
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: todoCell)
        tableView.tableHeaderView = searchBar
//        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(hexString: self.selectedCategory!.colour, withAlpha: 0.5)
        
        searchBar.sizeToFit()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        
        view.backgroundColor = .white

    }
    
    func configNavigationBar() {
        navigationItem.title = selectedCategory?.name
        
        
        if let colourHex = selectedCategory?.colour {
            
            navigationController?.navigationBar.barTintColor = UIColor(hexString: colourHex)
            searchBar.barTintColor = UIColor(hexString: colourHex)
            searchBar.searchTextField.backgroundColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(UIColor(hexString: colourHex)!, returnFlat: true)]
            navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString: colourHex)!, returnFlat: true)
            navigationItem.rightBarButtonItem?.tintColor = ContrastColorOf(UIColor(hexString: colourHex)!, returnFlat: true)

            
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        navigationController?.navigationBar.topItem?.title = "Back To Home"
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return "Todo Tasks"
        default:
            return "Done Tasks"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return todoItems.count ?? 1
        } else {
            return doneItems.count ?? 1
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let item = listItems?[indexPath.row] {
//            do {
//                try realm.write {
//                    item.done = !item.done
//                }
//            } catch {
//                print("Error")
//            }
//        }
        
//        todoItems![indexPath.row].done = !todoItems![indexPath.row].done
//        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: todoCell, for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        switch(indexPath.section) {
        case 0:
            if todoItems.isEmpty == false {
                let item = todoItems[indexPath.row]
            
                cell.textLabel!.text = item.title
                
                cell.accessoryType = item.done == true ? .checkmark : .none
            } else {
                cell.textLabel?.text = "No Items Added"
            }
        default:
            if doneItems.isEmpty == false {
                let item = doneItems[indexPath.row]
                cell.textLabel!.text = item.title
                
                cell.accessoryType = item.done == true ? .checkmark : .none
            } else {
                cell.textLabel?.text = "No Items Added"
            }
        }
        
        if let colour = UIColor(hexString: selectedCategory!.colour)!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(listItems!.count)) {
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
        }
        
        
        

        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = listItems?[indexPath.row] {
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
                    self.loadItems()
                    

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
        listItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        todoItems.removeAll()
        doneItems.removeAll()
        for item in listItems! {
            if item.done == false {
                todoItems.append(item)
            } else {
                doneItems.append(item)
            }
        }
       
        
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

extension TodoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        listItems = listItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
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
extension TodoViewController: SwipeTableViewCellDelegate {
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = orientation == .right ? .destructive : .selection
//        
//        
//        return options
//    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        switch(indexPath.section){
        case 0:
            if orientation == .right {

                let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                    let item = self.todoItems[indexPath.row]
                        do {
                            try self.realm.write{
                                self.realm.delete(item)
                            }
                        } catch {
                            print("Error with \(error)")
                        }
                    self.loadItems()
                    tableView.reloadData()
                }

                // customize the action appearance
                deleteAction.image = #imageLiteral(resourceName: "Trash Icon")
                
                return [deleteAction]
                } else {
                    let doneAction = SwipeAction(style: .default, title: "Done", handler: {(action, indexPath) in
                        let item = self.todoItems[indexPath.row]
                            do {
                                try self.realm.write{
                                    item.done = true
                                    tableView.reloadData()
                                }
                            } catch {
                                print("Error")
                            }
                            self.loadItems()
                            tableView.reloadData()
                        
                    })
                    doneAction.backgroundColor = .systemGreen
                    return [doneAction]
                }
        default:
            return nil
        }
        
    }
    
}
