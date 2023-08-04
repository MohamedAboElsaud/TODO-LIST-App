//
//  TodoDetailsVC.swift
//  TODO LIST
//
//  Created by mohamed ahmed on 28/07/2023.
//

import UIKit

class TodoDetailsVC: UIViewController {
    
    var todo:Todo!
    var index:Int!
    @IBOutlet weak var todoDetails: UILabel!
    @IBOutlet weak var todoTitle: UILabel!
    @IBOutlet weak var todoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        NotificationCenter.default.addObserver(self, selector: #selector(editTodo), name: NSNotification.Name("edit"), object: nil)
    }
    @objc func editTodo(notifiction:Notification){
        if let todo=notifiction.userInfo?["editTodo"] as? Todo{
            self.todo=todo
            setUpUI()
        }
        
        
    }
    func setUpUI(){
        todoTitle.text=todo.title
        todoDetails.text=todo.details
        todoImageView.image=todo.image
    }
    @IBAction func addbutton(_ sender: Any) {
        if let vc=storyboard?.instantiateViewController(identifier: "NewTodoAdd") as? NewTodoAdd
        {
            vc.isCreation=false
            vc.editedTodo=todo
            vc.editTodoIndex=index
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    @IBAction func deleteTodoButton(_ sender: Any) {
        let confirmAlert=UIAlertController(title: "are you delete this note", message: "delete note", preferredStyle: .alert)
        let okAlert=UIAlertAction(title: "ok", style: .destructive,handler: {
            ok in
            
            NotificationCenter.default.post(name: NSNotification.Name("deleteTodo"), object: nil, userInfo: ["index":self.index!])
            
            let alert=UIAlertController(title: "deleted", message: "sucess delete", preferredStyle: .alert)
            let close=UIAlertAction(title: "ok", style: UIAlertAction.Style.default,handler: {_ in
                self.navigationController?.popViewController(animated: true)

            })
            alert.addAction(close)
            self.present(alert, animated: true)
        })
        let cancelAlert=UIAlertAction(title: "Cancel", style: .cancel,handler: {_ in })
        confirmAlert.addAction(okAlert)
        confirmAlert.addAction(cancelAlert)
        present(confirmAlert, animated: true)
        
        
       
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
