//
//  CustomAlert.swift
//  Friend List
//
//  Created by phi.thai on 3/7/23.
//

import UIKit

protocol alertDelegate {
    func onCallBack(check: Bool, indexPath: IndexPath)
}

class CustomAlert: UIViewController {
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var alert: UIView!
    
    var tableView: UITableView?
    var friends: [Friend]?
    var indexPath: IndexPath?
    weak var viewController: UIViewController?
    var check = false
    
    var delegate: alertDelegate?
    
    init(tableView: UITableView, friends: [Friend], indexPath: IndexPath) {
        super.init(nibName: "CustomAlert", bundle: Bundle(for: CustomAlert.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        self.tableView = tableView
        self.friends = friends
        self.indexPath = indexPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.layer.cornerRadius = 14
    }
    
    @IBAction func closeClickHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmClickHandler(_ sender: Any) {
        check = true
        delegate?.onCallBack(check: check, indexPath: indexPath!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func show() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        
        windowScene?.keyWindow?.rootViewController?.present(self, animated: true)
    }
    
}
