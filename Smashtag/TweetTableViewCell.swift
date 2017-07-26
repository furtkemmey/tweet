//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by HsuKaiChieh on 18/07/2017.
//  Copyright © 2017 HKC. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    //Outlet
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    
    //Model or interface
    var tweet: Twitter.Tweet? { didSet{ updatUI() } }
    
    private func updatUI() {
        tweetTextLabel?.text = tweet?.text
        tweetUserLabel?.text = tweet?.user.description
        
        //get image
        if let profileImageURL = tweet?.user.profileImageURL {
            //FIXME: block main thread
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: profileImageURL)
                if let imageData = urlContents, profileImageURL == self?.tweet?.user.profileImageURL {
                    DispatchQueue.main.async { [weak self] in
                        self?.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        }else{
            tweetProfileImageView?.image = nil
        }
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            }else{
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        }else{
            tweetCreatedLabel?.text = nil
        }
    }
}
