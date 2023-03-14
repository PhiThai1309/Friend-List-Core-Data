//
//  ViewController.swift
//  Friend List
//
//  Created by phi.thai on 3/6/23.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate, alertDelegate {
    
    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate) .persistentContainer.viewContext
    
    var friends: [Friend] = []
    
    var initCount = 0;
    
    @IBOutlet weak var friendsCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    func onClickHandler(_ cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            print("Tapped at \(indexPath)")
            let alert = CustomAlert(tableView: tableView, friends: friends, indexPath: indexPath)
            alert.delegate = self
            alert.show()
        }
    }
    
    func onCallBack(check: Bool, indexPath: IndexPath) {
        if check {
            friends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.friendsCount.text = "You have " + String(self.friends.count) + (self.friends.count <= 1 ? " friend" : " friends")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        tableView.refreshControl = refreshControl
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        if friends.count != initCount {
            friends.removeAll()
            tableView.reloadData()
            fetch()
        }
        
        // somewhere in your code you might need to call:
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let friend = friends[indexPath.row]
        
        // Fetch a cell of the appropriate type.
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        // Configure the cell’s contents.
        cell.set(img: friend.gender ?? "0", name: friend.name ?? "0", status: friend.status ?? "0", email: friend.email ?? "0")
        cell.delegate = self
        return cell
    }
    
    func fetch() {
        self.DeleteAllData()
        // Create a URLRequest for an API endpoint
        let url = URL(string: "https://gorest.co.in/public/v2/users")!
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                
                if (response.statusCode != 200) {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context!] = self.context


                    _ = try decoder.decode([Friend].self, from: data)
                    try self.context.save()
                    
                } catch {
                    print("JSONSerialization error:", error)
                }

                self.fetchDtb()
                
                
                DispatchQueue.main.async{
                    
                    self.initCount = self.friends.count
                    self.friendsCount.text = "You have " + String(self.friends.count) + (self.friends.count <= 1 ? " friend" : " friends")
                    self.tableView.reloadData()
                }
                
            } else {
                print(error!)
            }
        }
        task.resume()
    }
    
    func fetchDtb() {
        do {
            self.friends = try context.fetch(Friend.fetchRequest())
        } catch {
            print ("Error")
        }
    }
    
    func DeleteAllData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Friend"))
        do {
            try managedContext.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
    }
}

