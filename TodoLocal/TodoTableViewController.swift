//
//  TodoTableViewController.swift
//  TodoLocal
//
//  Created by Mark Meretzky on 4/2/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

// The model of this app is the todos property of the TodoTableViewController.
// We will change the app to use the Amazon Web Services DynamoDB database instead.

import UIKit;

class TodoTableViewController: UITableViewController {
    var todos: [Todo] = [Todo](); //The model is an array of Todo instances, initially empty.

    override func viewDidLoad() {
        super.viewDidLoad();

        // Uncomment the following line to preserve selection between presentations
        // clearsSelectionOnViewWillAppear = false;

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        navigationItem.leftBarButtonItem = editButtonItem;
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TodoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell;

        // Configure the cell ...
        let todo: Todo = todos[indexPath.row];
        cell.nameLabel.text = todo.name;
        cell.descriptionLabel.text = todo.description;
        cell.idLabel.text = todo.id;
        return cell;
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true;
    }
    */

    // Override to support editing the table view.

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row);                    // Delete the instance from the model.
            tableView.deleteRows(at: [indexPath], with: .fade); // Delete the cell from the table view.
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Protocol UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 4 + 21 + 17 + 17 + 4;   //top and bottom margins, plus the heights of the three UILabels
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender);
        
        guard let indexPath: IndexPath = tableView.indexPathForSelectedRow else {
            //The user pressed the + button, so there is no information we need to
            //send on ahead to the ViewController.
            return;
        }
        
        // Get the new view controller using segue.destination.
        guard let viewController: ViewController = segue.destination as? ViewController else {
            fatalError("segue to unexpected view controller \(type(of: segue.destination))");
        }
        
        // Pass the selected object to the new view controller.
        viewController.todo = todos[indexPath.row];
    }
    
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "SaveSegue" else {
            return;   //If user pressed Cancel, do nothing.
        }
        
        guard let viewController: ViewController = unwindSegue.source as? ViewController else {
            fatalError("unwound from unexpected view controller \(type(of: unwindSegue.source))");
        }
        
        guard let todo: Todo = viewController.todo else {
            fatalError("received a nil Todo");
        }
        
        if let indexPath: IndexPath = tableView.indexPathForSelectedRow {
            //User updated the properties of an existing Todo.
            todos[indexPath.row].name = todo.name;
            todos[indexPath.row].description = todo.description;
            tableView.reloadRows(at: [indexPath], with: .none);
        } else {
            //User created a new Todo.
            let newIndexPath: IndexPath = IndexPath(row: todos.count, section: 0);
            todos.append(todo);
            tableView.insertRows(at: [newIndexPath], with: .automatic);
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        tableView.reloadData();
    }

}
