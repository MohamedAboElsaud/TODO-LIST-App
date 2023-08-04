//
//  TodoStorage.swift
//  TODO LIST
//
//  Created by mohamed ahmed on 04/08/2023.
//

import UIKit
import CoreData

class TodoStorage{
    
    static func storeTodo(todo:Todo){
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
    
    static  func updateTodo(todo:Todo,index:Int){
        
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
    
    static  func getTodo()->[Todo]{
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

static func deleteTodoo(index:Int){
    
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
}
