//
//  TodosVC.swift
//  TODO LIST
//
//  Created by mohamed ahmed on 28/07/2023.
//

import UIKit
import CoreData

class TodosVC: UIViewController {
    
    var todosArray:[Todo]!
    @IBOutlet weak var todosTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        todosArray=TodoStorage.getTodo()
        //
        NotificationCenter.default.addObserver(self, selector: #selector(addNewTodo), name: NSNotification.Name("addTodo"), object: nil)
        
        //
        NotificationCenter.default.addObserver(self, selector: #selector(editTodo), name: NSNotification.Name("edit"), object: nil)
        
        //
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTodo), name: NSNotification.Name("deleteTodo"), object: nil)
        todosTableView.dataSource=self
        todosTableView.delegate=self
        
    }
    
    
    @objc  func addNewTodo(notification:Notification){
        if let todo=notification.userInfo?["todo"] as? Todo{
            todosArray.append(todo)
            todosTableView.reloadData()
            TodoStorage.storeTodo(todo: todo)
        }
        
    }
    @objc func editTodo(notifiction:Notification){
        if let todo=notifiction.userInfo?["editTodo"] as? Todo{
            if let index=notifiction.userInfo?["editIndex"] as? Int{
                todosArray[index]=todo
                todosTableView.reloadData()
                TodoStorage.updateTodo(todo: todo, index: index)
            }
            
        }
    }
    @objc func deleteTodo(notifiction:Notification){
        
        if let index=notifiction.userInfo?["index"] as? Int{
            todosArray.remove(at: index)
            todosTableView.reloadData()
            TodoStorage.deleteTodoo(index: index)
        }
        
        
    }
    
    
    
    
    
  
    
}
extension TodosVC :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
        cell.todoTitleLabel.text=todosArray[indexPath.row].title
        cell.todoImageView.image=todosArray[indexPath.row].image
        cell.todoImageView.layer.cornerRadius=cell.todoImageView.frame.width/2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let todo=todosArray[indexPath.row]
        let vc=storyboard?.instantiateViewController(identifier: "TodoDetailsVC") as? TodoDetailsVC
        if let viewController=vc {
            
            viewController.todo=todo
            viewController.index=indexPath.row
            navigationController?.pushViewController(viewController, animated: true)
            //        present(vc, animated: true)
        }
        
    }
    
}
