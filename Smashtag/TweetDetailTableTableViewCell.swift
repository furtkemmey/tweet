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
    
    private func updateUI() {
        hashTagLabel?.text = tweetData
//        if let section =  sections{
//            switch section {
//            case 0:
//                hashTagLabel?.text = tweetDataHashTag
//            default:
//                hashTagLabel?.text = " "
//            }
//        }
    }
}
