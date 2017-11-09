//
//  KamusCell.swift
//  KamusEnglishIndonesiaiOS
//
//  Created by Rizki Syaputra on 11/9/17.
//  Copyright © 2017 Rizki Syaputra. All rights reserved.
//

import UIKit

class KamusCell: UITableViewCell {
    @IBOutlet weak var labelIndonesia: UILabel!
    
    @IBOutlet weak var labelEnglish: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
