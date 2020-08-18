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


class TodoView: UITableViewController {
    //MARK: - Properties
    let realm = try! Realm()
    
    let searchBar = UISearchBar(frame: .zero)
    
    var listItems: Results<Item>?
    var todoItems = [Item]()
    var doneItems = [Item]()
    var isSearching: Bool = false
    var selectedCategory: Category? {
        didSet {
            loadItems()
            tableView.backgroundColor = UIColor(hexString: self.selectedCategory!.colour, withAlpha: 1)?.lighten(byPercentage: 20)
        }
    }
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InitView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - Init
    func InitView(){
        //        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: todoCell)
        tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: todoCell)
        tableView.tableHeaderView = searchBar
        //        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        searchBar.sizeToFit()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        
        
        
    }
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if !isSearching {
            return 2
        }
        return 1
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !isSearching {
            switch(section) {
            case 0:
                return "Todo Tasks"
            default:
                return "Done Tasks"
            }
        }
        return "Result"
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if !isSearching {
            if section == 0 {
                return todoItems.count ?? 1
            } else {
                return doneItems.count ?? 1
            }
        }
        return listItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: todoCell, for: indexPath) as! ItemTableViewCell
        cell.delegate = self
        if !isSearching {
            switch(indexPath.section) {
            case 0:
                if todoItems.count != 0 {
                    let item = todoItems[indexPath.row]
                    cell.name = item.title
                    let date = item.dateDue
                    cell.date = item.detailText(for: item)
                    cell.completed = item.done
                    
                }
            default:
                if doneItems.isEmpty == false {
                    let item = doneItems[indexPath.row]
                    cell.lblTitle!.text = item.title
                    cell.lblDue.text = item.detailText(for: item)
                    cell.completed = item.done
                }
            }
        } else {
            if listItems?.count != 0 {
                let item = listItems![indexPath.row]
                cell.name = item.title
                let date = item.dateDue
                cell.date = item.detailText(for: item)
                cell.completed = item.done
            }
        }
        
        if let colour = UIColor(hexString: selectedCategory!.colour)!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(listItems!.count * 2)) {
            cell.backgroundColor = colour
            cell.lblTitle?.textColor = ContrastColorOf(colour, returnFlat: true)
            cell.lblDue?.textColor = ContrastColorOf(colour, returnFlat: true)
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
    //
    
    //MARK: Handler
    
    //
    
    func loadItems() {
        
        //RealM
        if !isSearching {
            listItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        }
        todoItems.removeAll()
        doneItems.removeAll()
        for item in listItems! {
            if item.done == false {
                todoItems.append(item)
            } else {
                doneItems.append(item)
            }
        }
        tableView.reloadData()
        
    }
    
    
    
    
}

extension TodoView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        listItems = listItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        isSearching = true
        tableView.reloadData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            isSearching = false
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                
            }
        }
    }
    
    
}
extension TodoView: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right {
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                var item: Item
                if !self.isSearching {
                item = indexPath.section == 0 ? self.todoItems[indexPath.row] : self.doneItems[indexPath.row]
                } else {
                    item = self.listItems![indexPath.row]
                }
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
            let undoneAction = SwipeAction(style: .default, title: "Not Done", handler: {(action, indexPath) in
                let item = self.doneItems[indexPath.row]
                do {
                    try self.realm.write{
                        item.done = false
                        item.dateCompleted = nil
                        tableView.reloadData()
                    }
                } catch {
                    print("Error")
                }
                self.loadItems()
                tableView.reloadData()
                
            })
            undoneAction.backgroundColor = .systemGray
            let doneAction = SwipeAction(style: .default, title: "Done", handler: {(action, indexPath) in
                let item = self.todoItems[indexPath.row]
                do {
                    try self.realm.write{
                        item.done = true
                        let date = Date()
                        item.dateCompleted = date
                        tableView.reloadData()
                    }
                } catch {
                    print("Error")
                }
                self.loadItems()
                tableView.reloadData()
                
            })
            doneAction.backgroundColor = .systemGreen
            return indexPath.section == 1 ? [undoneAction] : [doneAction]
            
        }
    }
    
    
}
