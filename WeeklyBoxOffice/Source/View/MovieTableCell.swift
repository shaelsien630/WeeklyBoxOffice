//
//  MovieTableCell.swift
//  WeeklyBoxOffice
//
//  Created by 최서희 on 2/24/24.
//

import Foundation

import UIKit

class MovieTableCell: UITableViewCell {
    
    static let identifier = "MovieCell"
    
    @IBOutlet weak var index: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var openDate: UILabel!
    @IBOutlet weak var audiAcc: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var rankInten: UILabel!
    @IBOutlet weak var rankOldAndNew: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
