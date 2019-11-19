//
//  SearchTableViewController.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-11-12.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import Just

class SearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    var trendingsubs = [String]()
    var searchstring: String?
    var searchstate = "empty"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search Posts, Subreddits etc."
        
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        
        //makes the remaining lines disappear
        tableView.tableFooterView = UIView()
        makeTrendingSubs()
        
    }
    
    func makeTrendingSubs() {
        let decoder = JSONDecoder()
        let postJson = Just.get("https://www.reddit.com/api/trending_subreddits.json")
        if let jsonPosts = try? decoder.decode(Trending.self, from: postJson.content ?? Data()) {
            trendingsubs = jsonPosts.subreddit_names
        } else {
            print("can't get trending subs")
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        if text == "" {
            searchstate = "empty"
        } else {
            searchstate = "search"
        }
        self.searchstring = text
        self.tableView.reloadData()
        print(text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button clicked")
        let vc = storyboard?.instantiateViewController(withIdentifier: "DisplayPosts") as! PostsViewController
        vc.subreddit = "Search"
        vc.searchstring = searchBar.text
        navigationController?.pushViewController(vc, animated: true)
        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        if searchstate == "empty" {
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
            header.textLabel?.text = "Trending"
            header.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            if section == 1 {
                header.textLabel?.text = "Trending"
                header.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
                header.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if searchstate == "empty" {
            return 40
        } else {
            if section == 0 {
                return 0
            } else {
                return 40
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchstate == "empty" {
            return 1
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchstate == "empty" {
            return trendingsubs.count
        } else {
            if section == 0 {
                return 3
            } else {
                return trendingsubs.count
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        
        if searchstate == "empty" {
            cell.textLabel?.text = trendingsubs[indexPath.row]
            cell.accessoryType = .disclosureIndicator
        } else {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = "Search Subreddits for: " + (searchstring ?? "")
                case 1:
                    cell.textLabel?.text = "Search Posts for: " + (searchstring ?? "")
                case 2:
                    cell.textLabel?.text = "Go to User: " + (searchstring ?? "")
                default:
                    cell.textLabel?.text = ""
                }
                
            } else {
                cell.textLabel?.text = trendingsubs[indexPath.row]
                cell.accessoryType = .disclosureIndicator
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "DisplayPosts") as? PostsViewController {
            
            if searchstate == "empty" {
                vc.subreddit = trendingsubs[indexPath.row]
            } else {
                if indexPath.section == 0 {
                    switch indexPath.row {
                    case 0:
                        vc.subreddit = searchstring
                    case 1:
                        vc.subreddit = searchstring
                    case 2:
                        vc.subreddit = searchstring
                    default:
                        vc.subreddit = searchstring
                    }
                    
                } else {
                    vc.subreddit = trendingsubs[indexPath.row]
                }
            }
            
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }


}
