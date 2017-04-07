//
//  MovieActorCollectionViewCell.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/10/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit
import RxCocoa

class MovieActorCollectionViewCell: UICollectionViewCell, UICustomCellRegister {

    static var identifier: String = "MovieActorCollectionViewCell"

    @IBOutlet weak var actorImageView: RoundedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var characterLAbel: UILabel!

    func configure(cast: Cast) {
        if let profilePath = cast.profilePath {
            self.actorImageView.af_setImage(withURL: profilePath)
        }

        self.titleLabel.text = cast.name
        self.characterLAbel.text = cast.character

        self.actorImageView.borderWidth = 1.0
    }

}
