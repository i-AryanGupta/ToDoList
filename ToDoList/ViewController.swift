//
//  ViewController.swift
//  ToDoList
//
//  Created by Yashom on 18/09/24.
//

import UIKit
// we also confirm to UITableViewDataSource which is a way to supply 2 functions(tableView that supply to our to table)
class ViewController: UIViewController, UITableViewDataSource {
    
    
    // table view to show rows basically  list of rows and each one hold the entry
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []  // saved item in array
        title = "To-do-List"
        view.addSubview(table)
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self , action: #selector(didTapAdd)) // plus button at right top of phone
         
        
    }
    
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "New Item", message: "Enter new to do list items!", preferredStyle: .alert)
        
        alert.addTextField{field in
            field.placeholder = "Enter item ..."}
        
        alert.addAction(UIAlertAction(title: "Cancel", style:  .cancel, handler: nil))
        //in handler we get the input of the textfield
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] (_) in
            if let fields = alert.textFields?.first { // unwrap the textfield beacause they are optional
                if let txt = fields.text, !txt.isEmpty {
                    // Enter new to-do-list item
                    print(txt)
                    
                    // this is should be occur on main thread  because we updating ui and closures always excuted in asychronus manner
                    // and we also using [weak self] in handler to not cause any memory leak
                    // we use user default to save the data in user device. if we not using after app closing data will be vanish
                    //main thread
                    DispatchQueue.main.async {
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentItems.append(txt)
                        UserDefaults.standard.setValue(currentItems, forKey: "items" )
                        self?.items.append(txt)
                        self?.table.reloadData()
                    }
                }
            }
        }))
        
        present(alert,animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        table.frame = view.bounds // we saying frame of the table is entirely of the view
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return items.count
        // number of rows is number of items in an array
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:  indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

}

