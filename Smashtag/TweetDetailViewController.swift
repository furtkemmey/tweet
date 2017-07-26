//
//  TweetDetailViewController.swift
//  Smashtag
//
//  Created by HsuKaiChieh on 20/07/2017.
//  Copyright © 2017 HKC. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailViewController: UIViewController {
    //Outlet
    @IBOutlet weak var tweetImageView: UIImageView!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetHashTag: UILabel!
    @IBOutlet weak var tweetURL: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var tweetCreateDateLabel: UILabel!
    @IBOutlet weak var UIViewOutlet: UIView! {
        didSet {
            //MARK: Pinch
            let pinchRecognizer = UITapGestureRecognizer(target: self, action: #selector(OpenURL(URLRecognizer:) ))
            pinchRecognizer.numberOfTapsRequired = 1
            UIViewOutlet.addGestureRecognizer(pinchRecognizer)
        }
    }
    func OpenURL(URLRecognizer tabRecognizer: UITapGestureRecognizer) {
        if tabRecognizer.state == .ended {
            if let URLString0 = tweetURL?.text, let URLString = URL(string: URLString0) {
                if #available(iOS 10.0, *) {
                    let options = [UIApplicationOpenURLOptionUniversalLinksOnly : false]
                    UIApplication.shared.open(URLString, options: options, completionHandler: nil)
                }else {
                    UIApplication.shared.openURL(URLString)
                }
            }
        }
    }
    
    //Model
    var tweet: Twitter.Tweet?{ didSet{ updateUI() } }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    
    private func updateUI() {
//        tweetTextLabel?.text = tweet?.text
        twitterLabel?.text = tweet?.user.description
        
        
        //hashtag
        var tagTextAttString: NSMutableAttributedString {
            let temp = NSMutableAttributedString()
            let tempURL = NSMutableAttributedString()
            let attributesBlue = [NSForegroundColorAttributeName: UIColor.blue, NSBackgroundColorAttributeName: UIColor.yellow]
            let attributesBrown = [NSForegroundColorAttributeName: UIColor.brown]
            let attributesOrange = [NSForegroundColorAttributeName: UIColor.orange]
            
            guard let textString = tweet?.text,
                let keyhashtags = tweet?.hashtags,
                let mentions = tweet?.userMentions,
                let URLStrings = tweet?.urls
            else{
                return temp
            }
            let attTextString = NSMutableAttributedString(string: (textString))// text label
            //URL
            for URLString in URLStrings {
                let attributedURLString = NSMutableAttributedString(string: URLString.keyword)

                attributedURLString.addAttributes( attributesBlue , range: NSRange(location: 0, length: URLString.nsrange.length) )
                tempURL.append(attributedURLString)
                //text lable
                attTextString.addAttributes(attributesBlue, range: URLString.nsrange)
            }
            //usermentions
            for mention in mentions {
                attTextString.addAttributes(attributesBrown, range: mention.nsrange)
            }
            //hashTag
            for keyhashtag in keyhashtags {
                let attributedString = NSMutableAttributedString(string: keyhashtag.keyword)
                //for tweetHashTag
                attributedString.addAttributes(attributesOrange, range: NSRange(location: 0, length: keyhashtag.nsrange.length))
                temp.append(attributedString);
                //text lable
                attTextString.addAttributes(attributesOrange, range: keyhashtag.nsrange)

            }
            tweetHashTag?.attributedText = temp
            tweetURL?.attributedText = tempURL
            return attTextString
        }
        tweetTextLabel?.attributedText = tagTextAttString
        
        //get image
        if let profileImageURL = tweet?.user.profileImageURL {
            //FIXME: block main thread
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: profileImageURL)
                if let imageData = urlContents, profileImageURL == self?.tweet?.user.profileImageURL {
                    DispatchQueue.main.async { [weak self] in
                        self?.tweetImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        }else{
            tweetImageView?.image = nil
        }
        //CreateDate
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            }else{
                formatter.timeStyle = .short
            }
            tweetCreateDateLabel?.text = formatter.string(from: created)
        }else{
            tweetCreateDateLabel?.text = nil
        }
        
    }
}
