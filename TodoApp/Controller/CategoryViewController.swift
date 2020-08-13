//
//  CategoryViewController.swift
//  TodoApp
//
//  Created by Trần Huy on 8/7/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: UITableViewController {
    
    //MARK: - Properties
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: CategoryCell)
        tableView.separatorStyle = .none
        loadCategories()
        print(realm.configuration.fileURL)
    }
    override func viewWillAppear(_ animated: Bool) {
        configNavigationView()

    }
    
    func configNavigationView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.title = "TodoApp"
        
        navigationController?.navigationBar.barTintColor = UIColor.systemBlue

        
        

    }
    
    
    //MARK: - Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell, for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"
        cell.delegate = self
        let cellColor = UIColor(hexString: self.categories![indexPath.row].colour)
        cell.backgroundColor = cellColor
        cell.textLabel?.textColor = ContrastColorOf(cellColor!, returnFlat: true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mainVC = TodoView()
        mainVC.selectedCategory = categories?[indexPath.row]
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    //MARK: - Selector
    //MARK: Add new Categories
    @objc func addBtnPressed() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default, handler: {(action) in
            if textField.hasText {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.colour = UIColor.randomFlat().hexValue()
                
                
                self.saveCategories(with: newCategory)
            }
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        alert.addAction(actionCancel)
        alert.addTextField(configurationHandler: {(feild) in
            textField = feild
            textField.placeholder = "Enter new Category"
            
        })
        present(alert, animated: true)
    }
    
    //MARK: - Handler
    func saveCategories(with category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error to save Category with \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            try categories = context.fetch(request)
//        } catch {
//            print("Error to load category with \(error)")
//        }
        tableView.reloadData()
    }
    
}
extension CategoryViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let category = self.categories?[indexPath.row] {
                do {
                    try self.realm.write{
                        for item in category.items {
                            self.realm.delete(item)
                        }
                        self.realm.delete(category)
                    }
                } catch {
                    print("Error with \(error)")
                }
                tableView.reloadData()
            }
        }
        
        
        

        // customize the action appearance
        deleteAction.image = #imageLiteral(resourceName: "Trash Icon")

        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
