//
//  MovieCrewCollectionViewCell.swift
//  TheMovie
//
//  Created by Valeriu POPA on 1/9/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import UIKit

class MovieCrewCollectionViewCell: UICollectionViewCell, UICustomCellRegister {

    @IBOutlet weak var crewNameLabel: UILabel!
    @IBOutlet weak var crewTypeLabel: UILabel!
    
    static var identifier: String = "MovieCrewCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(crew: Crew) {
        self.crewNameLabel.text = crew.name
        self.crewTypeLabel.text = crew.job
    }
}
