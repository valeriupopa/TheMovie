//
//  SideMenuTableViewCell.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/11/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell, UICustomCellRegister {
 
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static var identifier: String = "SideMenuTableViewCell"
    
    func configure(data: SideMenuData) {
        self.leftImageView.image = UIImage(named:data.leftImage)
        self.rightImageView.image = UIImage(named: data.rightImage)
        self.titleLabel.text = data.title
    }
}

struct SideMenuData {
    let leftImage: String
    let rightImage: String
    let title: String
}
