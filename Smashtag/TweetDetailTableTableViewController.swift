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
                self.ImageURL = tweet?.media[0].url
            } else {
                //get image
                self.ImageURL = tweet?.user.profileImageURL
            }
        }
    }

    @IBOutlet weak var Image: UIImageView!
    var  ImageURL: URL? {
        didSet {
            //FIXME: block main thread
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let url = self?.ImageURL {
                    let urlContents = try? Data(contentsOf: url)
                    if let imageData = urlContents, url == self?.ImageURL {
                        DispatchQueue.main.async { [weak self] in
                            self?.Image?.image = UIImage(data: imageData)
//                            let fullScreenSize = UIScreen.main.bounds.size
                            if (self?.Image.image?.size.width)! > (self?.Image.frame.size.width)!, (self?.Image.image?.size.height)! > (self?.Image.frame.size.height)! {
                                //too big
                               self?.Image.contentMode = UIViewContentMode.scaleAspectFit
                            } else {
                                self?.Image.contentMode = UIViewContentMode.center
                                self?.Image?.sizeToFit()
//                                self?.Image?.frame = CGRect(x: 0, y: 0, width: (self?.Image.frame.size.width)!, height: (self?.Image.image?.size.height)!)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.Image?.image = nil
                    }
                }
            }
        }
    }
    
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
                hashTagCell.sections = 0
                hashTagCell.tweetData = tweet?.hashtags[indexPath.row].keyword
            case 1:
                if let keyword = tweet?.urls[indexPath.row].keyword {
                    hashTagCell.sections = 1
                    hashTagCell.tweetData = keyword
                }
            case 2:
                if let keyword = tweet?.userMentions[indexPath.row].keyword {
                    hashTagCell.sections = 2
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
