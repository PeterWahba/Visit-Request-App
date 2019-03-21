//
//  ViewController.swift
//  Checklist
//
//  Created by Brian on 6/18/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//Constants

let REQUESTS_URL = "http://localhost:5000/api/requests"
let defaults = UserDefaults.standard


class ChecklistViewController: UITableViewController {

  var todoList: TodoList
  

    @IBAction func addItem(_ sender: Any) {
    
    let newRowIndex = todoList.todos.count
    _ = todoList.newTodo()
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    todoList = TodoList()
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getRequestsData(url: REQUESTS_URL)
    navigationController?.navigationBar.prefersLargeTitles = true
    
  }
    
    
    //MARK: - Networking for requests
    /***************************************************************/
    
//  Get Requests Data
    func getRequestsData (url: String) {
        let HTTPHeaders : [String:String] = ["x-auth-token": defaults.value(forKey: "userToken") as! String]
        Alamofire.request(url, method: .get,headers: HTTPHeaders).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success !, Got the request data")
                let requestJSON : JSON = JSON(response.result.value!)
                print(requestJSON)
                self.updateRequestsData(json: requestJSON)
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    //  Delete Requests Data
    func deleteRequestsData (url: String) {
              let HTTPHeaders : [String:String] = ["x-auth-token": defaults.value(forKey: "userToken") as! String]
        
        print("url to delete \(url)")
        Alamofire.request(url, method: .delete,headers: HTTPHeaders).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success !, Delete the request")
                let requestJSON : JSON = JSON(response.result.value!)
                print(requestJSON)
//                self.updateRequestsData(json: requestJSON)
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateRequestsData method here:
    func updateRequestsData(json : JSON){
        if let requestArray = json["data"].array {
            self.todoList.todos = []
            for item in requestArray {
                let newItem = ChecklistItem()
                
                newItem.requestID = item["_id"].stringValue
                newItem.requestTitle = item["title"].stringValue
                newItem.requestDescription = item["description"].stringValue
                newItem.requestStatus = item["status"].stringValue
                newItem.requestDate = item["visit_date"].stringValue

                self.todoList.todos.append(newItem)
            }
                self.tableView.reloadData()
        }

    }

    
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoList.todos.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    let item = todoList.todos[indexPath.row]
    configureText(for: cell, with: item)
    configureCheckmark(for: cell, with: item)
    
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      let item = todoList.todos[indexPath.row]
      configureCheckmark(for: cell, with: item)
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
    
    //MARK: - Delete Request
    /***************************************************************/
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    print("Request id : ")
    print(todoList.todos[indexPath.row].requestID)
    let delete_url = REQUESTS_URL + "/" + todoList.todos[indexPath.row].requestID
    self.deleteRequestsData(url: delete_url)
    todoList.todos.remove(at: indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }
    
  
  
  func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
    if let label = cell.viewWithTag(1000) as? UILabel {
      label.text = item.requestTitle
    }
  }
  
  func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
    guard let checkmark = cell.viewWithTag(1001) as? UILabel else {
      return
    }
    if item.checked {
      checkmark.text = "√"
    } else {
      checkmark.text = ""
    }
    item.toggleChecked()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddItemSegue" {
      if let itemDetailViewController = segue.destination as? ItemDetailViewController {
        itemDetailViewController.delegate = self
        itemDetailViewController.todoList = todoList
      }
    } else if segue.identifier == "EditItemSegue" {
      if let itemDetailViewController = segue.destination as? ItemDetailViewController {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
          let item = todoList.todos[indexPath.row]
          itemDetailViewController.itemToEdit = item
          itemDetailViewController.delegate = self
        }
      }
    }
  }
  
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
    navigationController?.popViewController(animated: true)
    let rowIndex = todoList.todos.count - 1
    let indexPath = IndexPath(row: rowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
    if let index = todoList.todos.index(of: item) {
      let indexPath = IndexPath(row: index, section: 0)
      if let cell = tableView.cellForRow(at: indexPath) {
        configureText(for: cell, with: item)
      }
    }
    navigationController?.popViewController(animated: true)
  }
  
  
}

