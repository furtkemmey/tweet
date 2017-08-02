//
//  TweetDetailTableTableViewCell.swift
//  Smashtag
//
//  Created by HsuKaiChieh on 28/07/2017.
//  Copyright © 2017 HKC. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailTableTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var hashTagLabel: UILabel!

    var tweetData: String? { didSet{ updateUI() } }
    var sections: Int?
    private func updateUI() {
        let attributesBlue = [NSForegroundColorAttributeName: UIColor.blue]
        let attributesBrown = [NSForegroundColorAttributeName: UIColor.brown]
        let attributesOrange = [NSForegroundColorAttributeName: UIColor.orange]
        guard let tweetDataString = tweetData,
              let section = sections
        else { return  }
        
        let attTextString = NSMutableAttributedString(string: (tweetDataString))// text label
            switch section {
            case 0:
                attTextString.addAttributes( attributesBrown , range: NSRange(location: 0, length: tweetDataString.count ) )
            case 1:
                attTextString.addAttributes( attributesBlue , range: NSRange(location: 0, length: tweetDataString.count ) )
            case 2:
                attTextString.addAttributes( attributesOrange , range: NSRange(location: 0, length: tweetDataString.count ) )
            default:
                hashTagLabel?.text = " "
        }
        hashTagLabel.attributedText = attTextString
    }
}
extension String {
    var count: Int {
        return self.characters.count
    }
}
