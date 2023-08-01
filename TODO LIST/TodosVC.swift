//
//  TodosVC.swift
//  TODO LIST
//
//  Created by mohamed ahmed on 28/07/2023.
//

import UIKit
import CoreData

class TodosVC: UIViewController {
    //mmmm
    //cjncjcc
    //
    let x="nnn"
    var todosArray:[Todo]!
    @IBOutlet weak var todosTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        todosArray=getTodo()
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
            storeTodo(todo: todo)
        }
        
    }
    @objc func editTodo(notifiction:Notification){
        if let todo=notifiction.userInfo?["editTodo"] as? Todo{
            if let index=notifiction.userInfo?["editIndex"] as? Int{
                todosArray[index]=todo
                todosTableView.reloadData()
                updateTodo(todo: todo, index: index)
            }

        }
    }
    @objc func deleteTodo(notifiction:Notification){
        
            if let index=notifiction.userInfo?["index"] as? Int{
                todosArray.remove(at: index)
                todosTableView.reloadData()
                deleteTodoo(index: index)
            }

        
    }
    
    func storeTodo(todo:Todo){
        guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext=appDelegate.persistentContainer.viewContext
        guard let todoEntity=NSEntityDescription.entity(forEntityName: "TodoEnt", in: manageContext) else { return }
        let todoobject=NSManagedObject.init(entity: todoEntity, insertInto: manageContext)
        todoobject.setValue(todo.title, forKey: "title")
        todoobject.setValue(todo.details, forKey: "details")
        if let image=todo.image{
           let imageData=image.jpegData(compressionQuality: 1.0)
            todoobject.setValue(imageData, forKey: "image")
        }
        
        do{
            try manageContext.save()
        }catch{
            print("error save core data")
        }
    }
    
    func updateTodo(todo:Todo,index:Int){
        
        guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else{return}
        let manageContext=appDelegate.persistentContainer.viewContext
        let fetchRequest=NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEnt")
        do{
            let result=try manageContext.fetch(fetchRequest) as![NSManagedObject]
            result[index].setValue(todo.title, forKey: "title")
            result[index].setValue(todo.details, forKey: "details")
            if let image=todo.image{
               let imageData=image.jpegData(compressionQuality: 1.0)
                result[index].setValue(imageData, forKey: "image")
            }
            try manageContext.save()
        }catch{
            print("error update todo")
        }
    }
    func getTodo()->[Todo]{
        var todos:[Todo]=[]
        guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else{return []}
        let manageContext=appDelegate.persistentContainer.viewContext
        let fetchRequest=NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEnt")

        do{
            let result=try manageContext.fetch(fetchRequest) as! [NSManagedObject]
            for todo in result{
                let title=todo.value(forKey: "title") as? String
                let details=todo.value(forKey: "details") as? String
                var image:UIImage?=nil
                if let imageContext=todo.value(forKey: "image") as? Data{
                    image=UIImage(data: imageContext, scale: 1)
                }
                let todoinstance=Todo(title: title!,details: details,image: image)
                todos.append(todoinstance)
            }
        }catch{
            print("error read todo")
        }
        return todos
    }
}
func deleteTodoo(index:Int){
    
    guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else{return}
    let manageContext=appDelegate.persistentContainer.viewContext
    let fetchRequest=NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEnt")
    do{
        var result=try manageContext.fetch(fetchRequest) as![NSManagedObject]
        result.remove(at: index)
        try manageContext.save()
    }catch{
        print("error update todo")
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
