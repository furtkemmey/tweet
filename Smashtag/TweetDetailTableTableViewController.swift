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
        if let count = tweet?.media.count {
            if count > 0 {
                if let  imageURL = tweet?.media[0].url {
                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        let urlContents = try? Data(contentsOf: imageURL)
                        if let imageData = urlContents, imageURL == self?.tweet?.media[0].url {
                            DispatchQueue.main.async { [weak self] in
                                self?.Image?.image = UIImage(data: imageData)
                            }
                        }
                    }
                    
                }
            } else {
                //get image
                if let profileImageURL = tweet?.user.profileImageURL {
                    //FIXME: block main thread
                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        let urlContents = try? Data(contentsOf: profileImageURL)
                        if let imageData = urlContents, profileImageURL == self?.tweet?.user.profileImageURL {
                            DispatchQueue.main.async { [weak self] in
                                self?.Image?.image = UIImage(data: imageData)
                            }
                        }
                    }
                }else{
                    Image?.image = nil
                }
            }
        }
        //get image
//        if let profileImageURL = tweet?.user.profileImageURL {
//            //FIXME: block main thread
//            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                let urlContents = try? Data(contentsOf: profileImageURL)
//                if let imageData = urlContents, profileImageURL == self?.tweet?.user.profileImageURL {
//                    DispatchQueue.main.async { [weak self] in
//                        self?.Image?.image = UIImage(data: imageData)
//                    }
//                }
//            }
//        }else{
//            Image?.image = nil
//        }
    }

    @IBOutlet weak var Image: UIImageView!
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
//        var count:Int = 0
//        if let countHash = tweet?.hashtags.count {
//            if countHash > 0 {
//                count += 1
//            }
//        }
//        if let countUrls = tweet?.urls.count  {
//            if countUrls > 0 {
//                count += 1
//            }
//        }
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let count = tweet?.hashtags.count {
                return count
            }
            return 0
        case 1:
            if let count = tweet?.urls.count {
                return count
            }
            return 0
        case 2:
            if let count = tweet?.userMentions.count {
                return count
            }
            return 0
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "hashTag", for: indexPath)
        if let hashTagCell = cell as? TweetDetailTableTableViewCell {
            switch indexPath.section {
            case 0:
                hashTagCell.tweetData = tweet?.hashtags[indexPath.row].keyword
            case 1:
                if let keyword = tweet?.urls[indexPath.row].keyword {
                    hashTagCell.tweetData = keyword
                }
            case 2:
                if let keyword = tweet?.userMentions[indexPath.row].keyword {
                    hashTagCell.tweetData = keyword
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
            return "HashTag-\(section)"
        case 1:
            return "URL-\(section)"
        case 2:
            return "Mentions-\(section)"
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
