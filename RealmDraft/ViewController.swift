//
//  ViewController.swift
//  RealmDraft
//
//  Created by Alex Son on 13.01.22.
//

import UIKit
import RealmSwift

// Define our model like regular Swift class
class ToDoListItem: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = NSDate()
}

class ViewController: UIViewController {
    
    var realm: Realm!
    // Read some data from the bundled Realm
    var toDoList: Results<ToDoListItem>{
        get {
            return realm.objects(ToDoListItem.self)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var tasks: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the default Realm
        realm = try! Realm()
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        let alertVC = UIAlertController(title: "New task", message: "Add new task", preferredStyle: .alert)
        alertVC.addTextField { (UITextField) in
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alertVC.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) -> Void in
            let todoItemTextField = (alertVC.textFields?.first)! as UITextField
            
            let newToDoListItem = ToDoListItem()
            newToDoListItem.name = todoItemTextField.text!
            
            // Persist our data
            
            try! self.realm.write({
                self.realm.add(newToDoListItem)
                
                self.tableView.insertRows(at: [IndexPath.init(row: self.toDoList.count-1, section: 0)], with: .automatic)
                
                
            })
        }
        
        alertVC.addAction(addAction)
        present(alertVC, animated: true, completion: nil)
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = toDoList[indexPath.row]
        cell.textLabel!.text = item.name
        cell.backgroundColor = .clear
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = toDoList[indexPath.row]
            try! self.realm.write ({
                self.realm.delete(item)
            })
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
