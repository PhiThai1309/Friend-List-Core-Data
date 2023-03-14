//
//  TableViewCell.swift
//  Friend List
//
//  Created by phi.thai on 3/6/23.
//

import UIKit

protocol TableViewCellDelegate {
    func onClickHandler(_ cell: TableViewCell)
}
class TableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var delegate: TableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func deleteHandler(_ sender: Any) {
        delegate?.onClickHandler(self)
    }
    
    func set(img: String, name: String, status: String, email: String) {
        self.img.image = UIImage(named: img + "-placeholder")
        self.name.text = name
        self.status.text = status
        self.email.text = email
    }

}
