//
//  CategoryViewController.swift
//  TodoApp
//
//  Created by Trần Huy on 8/5/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import CoreData
let CategoryCell = "CategoryCell"
class CategoryViewController: UITableViewController {
    
    //MARK: - Properties
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CategoryCell)
        configNavigationView()
        loadCategories()
    }
    
    func configNavigationView() {
        navigationController?.navigationBar.barTintColor = .systemBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white

    }
    
    
    //MARK: - Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainVC = MainViewController()
        mainVC.selectedCategory = categories[indexPath.row]
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    //MARK: - Selector
    //MARK: Add new Categories
    @objc func addBtnPressed() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default, handler: {(action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            
            self.categories.append(newCategory)
            self.saveCategories()
        })
        alert.addAction(action)
        alert.addTextField(configurationHandler: {(feild) in
            textField = feild
            textField.placeholder = "Enter new Category"
            
        })
        present(alert, animated: true)
    }
    
    //MARK: - Handler
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error to save Category with \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            try categories = context.fetch(request)
        } catch {
            print("Error to load category with \(error)")
        }
        tableView.reloadData()
    }
    
}
