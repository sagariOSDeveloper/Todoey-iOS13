//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import  CoreData

class TodoListViewController: UITableViewController {
    
    //    let defaults = UserDefaults.standard
    var itemsObject = [Item]()
    
    @IBOutlet weak var SearchBar: UISearchBar!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        SearchBar.delegate = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "This feature will add new item in your todoey list.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //                What will happen once the user clicks tha Add Item button on our UIAlert
            
            let newItem = Item(context: self.context )
            newItem.title = textField.text!
            newItem.done = false
            self.itemsObject.append(newItem)
            self.saveData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Save Data Method
    func saveData(){
        do{
            try context.save()
        }catch{
            print("Error Saving Context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Read Data Method
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemsObject = try context.fetch(request)
        }catch{
            print("Error reading data \(error)")
        }
    }
}

//MARK: - TableView DataSource Methods
extension TodoListViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsObject.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemsObject[indexPath.row]
        cell.textLabel?.text = item.title
        //  value =  condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        //        This works as code workss below
        //        if item.done {
        //            cell.accessoryType = .checkmark
        //        }else {
        //            cell.accessoryType = .none
        //        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    // Selecting any Row Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemsObject[indexPath.row].done = !itemsObject[indexPath.row].done
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - SearchBar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
    }
}
