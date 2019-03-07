//
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Brian on 6/19/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {

  weak var delegate: ItemDetailViewControllerDelegate?
  weak var todoList: TodoList?
  weak var itemToEdit: ChecklistItem?
  
  @IBOutlet weak var cancelBarButton: UIBarButtonItem!
  @IBOutlet weak var addBarButton: UIBarButtonItem!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var descTextField: UITextField!
    
  @IBAction func cancel(_ sender: Any) {
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done(_ sender: Any) {
    if let item = itemToEdit,
       let textTitle = titleTextField.text,
       let textDescription = descTextField.text {
      item.requestTitle = textTitle
      item.requestDescription = textDescription
        print("item is : \(item.requestID)")
        let param : [String : String] = ["title": titleTextField.text! ,"description" : descTextField.text! ]
        let edit_url = "http://localhost:5000/api/requests/\(item.requestID)"
editRequestsData(url: edit_url, parametersss: param)
      delegate?.itemDetailViewController(self, didFinishEditing: item)
    } else {
      if let item = todoList?.newTodo() {
        if let textFieldText = titleTextField.text,
            let textDescription = descTextField.text {
            item.requestTitle = textFieldText
            item.requestDescription = textDescription
            
            let param : [String : String] = ["title": textFieldText ,"description" : textDescription ]
            
            newRequestsData(url: "http://localhost:5000/api/requests", parametersss: param)
        }
        item.checked = false
        delegate?.itemDetailViewController(self, didFinishAdding: item)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let item = itemToEdit {
      title = "Edit Item"
      titleTextField.text = item.requestTitle
      addBarButton.isEnabled = true
    }
    navigationItem.largeTitleDisplayMode = .never
  }
    
    //MARK: - Networking for requests
    /***************************************************************/
    
    //  New Requests Data
    func newRequestsData (url: String, parametersss: [String : String]) {
        Alamofire.request(url, method: .post, parameters: parametersss).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success !, New the request data")
                let requestJSON : JSON = JSON(response.result.value!)
                print(requestJSON)
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    //  Edit Requests Data
    func editRequestsData (url: String, parametersss: [String : String]) {
        Alamofire.request(url, method: .put, parameters: parametersss).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success !, Edit the request data")
                let requestJSON : JSON = JSON(response.result.value!)
                print(requestJSON)
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
  
  override func viewWillAppear(_ animated: Bool) {
    titleTextField.becomeFirstResponder()
  }
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}

extension ItemDetailViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    titleTextField.resignFirstResponder()
    return false
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    guard let oldText = titleTextField.text,
          let stringRange = Range(range, in: oldText) else {
        return false
    }
    
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    if newText.isEmpty {
      addBarButton.isEnabled = false
    } else {
      addBarButton.isEnabled = true
    }
    return true
  }
  
  
}
