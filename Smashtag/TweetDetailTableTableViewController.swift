//
//  TweetDetailTableTableViewController.swift
//  Smashtag
//
//  Created by HsuKaiChieh on 28/07/2017.
//  Copyright © 2017 HKC. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailTableTableViewController: UITableViewController {

    
    
    //Model
    var tweet: Twitter.Tweet?{ didSet{ updateUI() } }
    
    private func updateUI() {
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        var count:Int = 0
        if let countHash = tweet?.hashtags.count {
            if countHash > 0 {
                count += 1
            }
        }
        if let countUrls = tweet?.urls.count  {
            if countUrls > 0 {
                count += 1
            }
        }
        return count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (tweet?.hashtags.count)!
        case 1:
            return (tweet?.urls.count)!
        default:
            return 0
        }
//        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "hashTag", for: indexPath)
        if let hashTagCell = cell as? TweetDetailTableTableViewCell {
            switch indexPath.section {
            case 0:
                hashTagCell.tweetData = tweet?.hashtags[indexPath.row].keyword
//                hashTagCell.sections = indexPath.section
            case 1:
                if let keyword = tweet?.urls[indexPath.row].keyword{
                hashTagCell.tweetData = keyword
//                hashTagCell.sections = indexPath.section
                }
            default:
                hashTagCell.tweetData = " "
            }
            
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "HashTag"
        case 1:
            return "URL"
        default:
            return nil
        }
    }
//    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "\(section)" + " Footer hashTag"
//        case 1:
//            return "\(section)" + " Footer URL"
//        default:
//            return nil
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }


}
