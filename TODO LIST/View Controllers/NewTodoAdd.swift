//
//  NewTodoAdd.swift
//  TODO LIST
//
//  Created by mohamed ahmed on 29/07/2023.
//

import UIKit

class NewTodoAdd: UIViewController {

    var isCreation=true
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    var editedTodo:Todo?
    var editTodoIndex:Int?
    @IBOutlet weak var detailsTodoTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if !isCreation{
            editButton.setTitle("Edit", for: .normal)
            
            navigationItem.title="edit todo"
            if let todo=editedTodo{
                titleTextField.text=todo.title
                detailsTodoTextView.text=todo.details
                imageView.image=todo.image
            }
        }
    }
    
    @IBAction func addTodoButton(_ sender: Any) {
        if isCreation{
            let todo=Todo(title: titleTextField.text!,details: detailsTodoTextView.text!,image: imageView.image)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"addTodo"), object: nil,userInfo: ["todo" : todo ])
            let alert=UIAlertController(title: "added", message: "succes add new note", preferredStyle: UIAlertController.Style.alert)
            let close=UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel,handler: {
                _ in self.tabBarController?.selectedIndex=0
                self.detailsTodoTextView.text=""
                self.titleTextField.text=""
                self.imageView=nil
            })
            alert.addAction(close)
            present(alert, animated: true)
            
        }
        else{
//            edit
            let todo=Todo(title: titleTextField.text!,details: detailsTodoTextView.text,image: imageView.image)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "edit"), object: nil, userInfo: ["editIndex" : editTodoIndex!,"editTodo" :todo])
            let alert=UIAlertController(title: "edited", message: "succes edit note", preferredStyle: UIAlertController.Style.alert)
            let close=UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel,handler: {
                _ in self.navigationController?.popViewController(animated: true)
                self.detailsTodoTextView.text=""
                self.titleTextField.text=""
                self.imageView=nil
            })
            alert.addAction(close)
            present(alert, animated: true)
        }
    }

    @IBAction func changeImageButton(_ sender: Any) {
        let imagePicker=UIImagePickerController()
        imagePicker.delegate=self
        imagePicker.allowsEditing=true
        present(imagePicker, animated: true)
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
extension NewTodoAdd :UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image=info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: true)
        imageView.image=image
    }
}
