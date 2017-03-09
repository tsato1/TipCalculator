//
//  MyTableViewCell.swift
//  TipCalculator
//
//  Created by Takahide Sato on 3/8/17.
//  Copyright © 2017 GreenTSato. All rights reserved.
//

import UIKit
protocol MyTalbeViewCellDelegate {
    func didTappSwitch(cell: MyTableViewCell)
}

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var registerSwitch: UISwitch!
    
    var delegate: MyTalbeViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWithModel(model: MyTalbeViewCellModel) {
        cellLabel.text = model.label
        registerSwitch.setOn(model.turnedON, animated: false)
    }
    
    @IBAction func switchValueChanged(_ sender: AnyObject) {
        delegate.didTappSwitch(cell: self)
    }
}
