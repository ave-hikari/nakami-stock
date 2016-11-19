//
//  TodoListViewController.swift
//  todoapp
//
//

import UIKit

enum TodoAlertViewType {
    case create, update(Int), remove(Int)
}

class TodoTableViewController : UIViewController, FUIAlertViewDelegate {
    
    var todo = TodoDataManager.sharedInstance
    
    var alert : UIAlertController?
    var flatAlert : FUIAlertView?
    //アラート指定
    var alertType : TodoAlertViewType?
    //tableview宣言
    var tableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 64))
        header.image = UIImage(named:"header")
        header.isUserInteractionEnabled = true
        
        let title = UILabel(frame: CGRect(x: 10, y: 20, width: 310, height: 44))
        title.text = "❤︎TO DO❤︎"
        //ヘッダーにタイトルを設定する
        header.addSubview(title)
        
        let button:UIButton! = UIButton.init(type: UIButtonType.system)
        button.frame = CGRect(x: 320 - 50, y: 20, width: 50, height: 44)
        button.setTitle("追加", for: UIControlState())
        //button押下時新しいtodoを作成する
        button.addTarget(self, action:#selector(TodoTableViewController.showCreateView), for: .touchUpInside)
        header.addSubview(button)
        
        let screenWidth = UIScreen.main.bounds.size.height
        self.tableView = UITableView(frame: CGRect(x: 0, y: 60, width: 320, height: screenWidth - 60))
        
        self.tableView!.dataSource = self
        self.tableView!.delegate = self
        
        //tableview,headerをadd
        self.view.addSubview(self.tableView!)
        self.view.addSubview(header)
    }
    
    func showCreateView() {
        
        self.alertType = TodoAlertViewType.create
        
        self.alert = UIAlertController(title: "Todoを追加する", message: nil, preferredStyle: .alert)
        
//        self.alert = FUIAlertView(title: "タイトル", message: "message", delegate: self, cancelButtonTitle: "キャンセル")
        
        
        self.alert!.addTextField(configurationHandler: { textField in
            textField.delegate = self
            textField.returnKeyType = .done
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        self.alert!.addAction(okAction)
        
        self.present(self.alert!, animated: true, completion: nil)
    }
}

/**
 * UITextFieldDelegateに関するものはすべてこの中
 *
 */
extension TodoTableViewController : UITextFieldDelegate {
    //テキストフィールドの編集が完了した（詳細に言うと完了した直前）
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if let type = self.alertType {
            switch type {
            case .create:
                let todo = TODO(title: textField.text!)
                if self.todo.create(todo) {
                    textField.text = nil
                    self.tableView!.reloadData()
                }
            case let .update(index):
                let todo = TODO(title: textField.text!)
                if self.todo.update(todo, at:index) {
                    textField.text = nil
                    self.tableView!.reloadData()
                }
            case .remove(_):
                break
            }
        }
        
        self.alert!.dismiss(animated: false, completion: nil)
        return true
    }
}

//自作したセルに関するものはこの中
extension TodoTableViewController : TodoTableViewCellDelegate {
    
    func updateTodo(_ index: Int) {
        self.alertType = TodoAlertViewType.update(index)
        
        self.alert = UIAlertController(title: "編集", message: nil, preferredStyle: .alert)
        self.alert!.addTextField(configurationHandler: { textField in
            textField.text = self.todo[index].title
            textField.delegate = self
            textField.returnKeyType = .done
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        self.alert!.addAction(okAction)
        
        self.present(self.alert!, animated: true, completion: nil)
    }
    
    func removeTodo(_ index: Int) {
        self.alertType = TodoAlertViewType.remove(index)
        
        self.alert = UIAlertController(title: "削除します。よろしいですか", message: nil, preferredStyle: .alert)
//        self.flatAlert = FUIAlertView(title: "削除します。よろしいですか", message: nil, delegate: self, cancelButtonTitle: "キャンセル")
//        self.flatAlert?.show()
        
        
        SweetAlert().showAlert("Are you sure?", subTitle: "削除してもよろしいですか？", style: AlertStyle.warning, buttonTitle:"Cancel", buttonColor:AppUtility.colorWithHexString("a9a9a9") , otherButtonTitle:  "Delete", otherButtonColor:AppUtility.colorWithHexString("ff6347")) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                // Cancelを選択した時の処理
                
            }
            else {
                
                // Deleteを選択した時の処理
                self.todo.remove(index)
                self.tableView!.reloadData()
                SweetAlert().showAlert("Delete!", subTitle: "削除しました", style: AlertStyle.success)
            }
        }
        
//        self.alert!.addAction(UIAlertAction(title: "Delete", style: .Destructive) { action in
//            self.todo.remove(index)
//            self.tableView!.reloadData()
//            })
//        self.alert!.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
//        self.presentViewController(self.alert!, animated: true, completion: nil)
    }
}


/**
 * UITableView (dataSource, delegate)に関するものはすべてこの中
 *
 */
extension TodoTableViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todo.size
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TodoTableViewCell(style: .default, reuseIdentifier: nil)
        cell.delegate = self
        
        cell.textLabel?.text = self.todo[indexPath.row].title
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セルを選択しました！ #\(indexPath.row)!")
    }
}
