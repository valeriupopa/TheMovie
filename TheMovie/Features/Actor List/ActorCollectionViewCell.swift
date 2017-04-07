//
//  ActorCollectionViewCell.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/11/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit

class ActorCollectionViewCell: UICollectionViewCell, UICustomCellRegister {

    // MARK: Properties + UI Actions
    static var identifier: String = "ActorCollectionViewCell"

    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var actorInfoLabel: UILabel!
    @IBOutlet weak var actorPopularityLabel: UILabel!
    @IBOutlet weak var actorAvatarImageView: UIImageView!

    @IBAction func moreInfoTapAction(_ sender: UIButton) {
        print("some details about actor")
    }

    // MARK: UI Configuration methods
    func configure(actor: Actor) {
        if let imageURL = actor.profilePath {
            self.actorAvatarImageView.af_setImage(withURL: imageURL)
        }
        self.actorNameLabel.text = actor.name
        self.actorInfoLabel.text = actor.info
        self.actorPopularityLabel.text = "\(Int(actor.popularity))"

        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10.0).cgPath
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = true
        self.clipsToBounds = false

    }
}
