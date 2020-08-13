//
//  MainViewController.swift
//  TodoApp
//
//  Created by Trần Huy on 8/10/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework
class MainViewController: UIViewController, MessageProtocol {
    //MARK: - Properties
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        configNavigationView()
    }
    
    //MARK: - Handler
    func initView() {
        view.backgroundColor = .white
        categories = realm.objects(Category.self)
        if categories!.isEmpty {
            let message = MessageController(text: "Tap the button to create your first Category", actionTitle: "Create Category", actionHandler: {[weak self] in
                self?.addCategory()
            })
            message.view.frame = self.view.bounds
            
            message.delegate = self
            message.willMove(toParent: self)
            view.addSubview(message.view)
            self.addChild(message)
            message.didMove(toParent: self)
        } else {
            let categoryVC = CategoryView()
            categoryVC.view.frame = self.view.bounds
            categoryVC.willMove(toParent: self)
            view.addSubview(categoryVC.view)
            self.addChild(categoryVC)
            categoryVC.didMove(toParent: self)
            
        }
    }
    
    func configNavigationView() {
           navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
           navigationItem.rightBarButtonItem?.tintColor = UIColor.white
           navigationItem.title = "TodoApp"
           
           navigationController?.navigationBar.barTintColor = UIColor.systemBlue
    }
    
    //MARK: - Selector
    
    @objc func addBtnPressed() {
        addCategory()
    }
    
    //MARK: - Handler
    func addCategory() {
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
    
    func saveCategories(with category: Category) {
            do {
                try realm.write{
                    realm.add(category)
                }
            } catch {
                print("Error to save Category with \(error)")
            }
        initView()
        
//            tableView.reloadData()
        }
        
        func loadCategories() {
            categories = realm.objects(Category.self)
            
        }
    // Protocol
    func handlerAddTask(for message: MessageController) {
        addBtnPressed()
    }
    

    

}
