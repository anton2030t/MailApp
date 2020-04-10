//
//  MailTableViewCell.swift
//  mailApp
//
//  Created by Антон Ларченко on 09.09.2019.
//  Copyright © 2019 Anton Larchenko. All rights reserved.
//

import UIKit

class MailTableViewCell: UITableViewCell {

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var textMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
