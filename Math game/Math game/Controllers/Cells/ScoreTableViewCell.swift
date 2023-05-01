//
//  ScoreTableViewCell.swift
//  Math game
//
//  Created by Aurelio Le Clarke on 01.05.2023.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var scoreLabel: UILabel!
    static let identifier = "cell"
    override func awakeFromNib() {
        super.awakeFromNib()
        scoreLabel.text = nil
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        //Reset to initial value
        
        scoreLabel.text = nil
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
