//
//  FitnessTableViewController.swift
//  Fitness Track
//
//  Created by Juan  on 6/30/19.
//  Copyright © 2019 New Horizon. All rights reserved.
//

import UIKit
import MongoSwift

class FitnessTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    // Create TableView
    let tableView = UITableView()
    
    private var userId: String?
    {
        return stitch.auth.currentUser?.id
    }
    
    // TableView Data Source
    fileprivate var fitnessItems = [FitnessItem]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nil, bundle: nil)
        
        // check to make sure a user is logged in
        // if they are, load the user's todo items and refresh the tableview
        if stitch.auth.isLoggedIn
        {
            itemsCollection.find(["owner_id": self.userId!]).toArray
            { result in
                switch result
                {
                    case .success(let fits):
                        self.fitnessItems = fits
                        
                        DispatchQueue.main.async
                        {
                        self.tableView.reloadData()
                        }
                    
                    case .failure(let e):
                        fatalError(e.localizedDescription)
                }
            }
        }
        
        else
        {
            // no user is logged in, send them back to the welcome view
            self.navigationController?.setViewControllers([WelcomeViewController()], animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Fitness"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        view.addSubview(self.tableView)
        self.tableView.frame = self.view.frame
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(self.addFitnessItem(_:)))
        
        let logoutButton = UIBarButtonItem(title: "Logout",
                                           style: .plain,
                                           target: self,
                                           action: #selector(self.logout(_:)))
        
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc func addFitnessItem(_ sender: Any)
    {
        let alertController = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Fitness item"
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let task = alertController.textFields?.first?.text {
                let fitnessItem = FitnessItem(id: ObjectId(),
                                        ownerId: self.userId!,
                                        task: task,
                                        checked: false)
                // optimistically add the item and reload the data
                self.fitnessItems.append(fitnessItem)
                self.tableView.reloadData()
                itemsCollection.insertOne(fitnessItem)
                { result in
                    
                    switch result
                    {
                        case .success:
                        // no action necessary
                        print("successfully inserted a document")
                        
                        case .failure(let e):
                            print("error inserting item, \(e.localizedDescription)")
                            // an error occured, so remove the item we just inserted and reload the data again to refresh the ui
                       
                        DispatchQueue.main.async
                        {
                            self.fitnessItems.removeLast()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }))
        
        self.present(alertController, animated: true)
    }
    
    @objc func logout(_ sender: Any)
    {
        stitch.auth.logout
            { result in
            
                switch result
                {
                    
                case .success:
                    DispatchQueue.main.async
                    {
                        self.navigationController?.setViewControllers([WelcomeViewController()], animated: true)
                    }
                    
                case .failure(let e):
                    print("Had an error logging out: \(e)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        var item = self.fitnessItems[indexPath.row]
        
        let title = item.checked ? NSLocalizedString("Undone", comment: "Undone") : NSLocalizedString("Done", comment: "Done")
        
        let action = UIContextualAction(style: .normal, title: title, handler: { _, _, completionHander in
            item.checked = !item.checked
            self.fitnessItems[indexPath.row] = item
            
            DispatchQueue.main.async
            {
                self.tableView.reloadData()
                completionHander(true)
            }
        })
        
        action.backgroundColor = item.checked ? .red : .green
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        guard case .delete = editingStyle else { return }
        
        let item = fitnessItems[indexPath.row]
        itemsCollection.deleteOne(["_id": item.id])
        { result in
            switch result
            {
            
                case .success:
                    self.fitnessItems.remove(at: indexPath.row)
                    DispatchQueue.main.async
                    {
                    self.tableView.reloadData()
                    }
                
            case .failure(let e):
                print("Error, could not delete: \(e.localizedDescription)")

            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.fitnessItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") ?? UITableViewCell(style: .default, reuseIdentifier: "TodoCell")
        cell.selectionStyle = .none
        
        let item = fitnessItems[indexPath.row]
        cell.textLabel?.text = item.task
        
        cell.accessoryType = item.checked ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        
        return cell
    }
    
}
