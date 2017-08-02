//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by HsuKaiChieh on 17/07/2017.
//  Copyright © 2017 HKC. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    //MARK:- Model or interface
    private var tweets = [Array<Tweet>]() {
        didSet {
            //print(tweets[0])
        }
    }
    //search
    var searchText: String? {
        didSet {
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            lastTwitterRequest = nil
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    //TextField
    @IBOutlet weak var searchTextField: UITextField! {
        didSet{
            searchTextField.delegate = self
        }
    }
    //delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }
    //Twitter request
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: "\(query) -filter:safe -filter:retweets", count: 100) //convence init
        }
        return nil
    }
    //Twitter search
    private var lastTwitterRequest: Twitter.Request? // for weak self checking
    private func searchForTweets() {
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets{ [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest {//check the request is really we want
                        self?.tweets.insert(newTweets, at: 0)
                        self?.tableView.insertSections([0], with: .fade)
                    }
                    self?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    @IBAction func refresh(_ sender: UIRefreshControl) {
        searchForTweets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        searchText = "#happy" //just for testing
    }
    
    // MARK: - UITabelViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //data
        let tweet: Tweet = tweets[indexPath.section][indexPath.row]
        //cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)

        //non-custom cells
//        cell.textLabel?.text = tweet.text
//        cell.detailTextLabel?.text = tweet.user.name
        
        if let tweetCell = cell as? TweetTableViewCell {
            //var tweet: Twitter.Tweet? { didSet{ updatUI() } }
            tweetCell.tweet = tweet //updateUI
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count-section)" + " Header"
    }
//    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return "\(tweets.count-section)" + " Footer"
//    }
        
    //MARK:- prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "tweetDetail":
                if let cell = sender as? TweetTableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    if let VCDetail = segue.destination as? TweetDetailViewController {
                        let tweet: Tweet = tweets[indexPath.section][indexPath.row]
                        VCDetail.tweet = tweet
                    }
                }
            case "tweetDetailTable":
                if let cell = sender as? TweetTableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    if let VCDetail = segue.destination as? TweetDetailTableTableViewController {
                        let tweet: Tweet = tweets[indexPath.section][indexPath.row]
                        VCDetail.tweet = tweet
                    }
                }
                
            default: break
            }
        }
    }
}
