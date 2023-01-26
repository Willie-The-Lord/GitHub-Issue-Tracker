//
//  OpenTableViewController.swift
//  Project3-1
//
//  Created by Sung-Jie Hung on 2023/1/23.
//

import UIKit

struct Issue: Codable {
    let title: String
    let createdAt: String
    let body: String
    let user: String
}

class OpenIssueTableViewController: UITableViewController {
    var openIssues = [Issue]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize the color of your UINavigationBar using UINavigationBarAppearance() to be red for open issues and green for closed issues.
        // https://developer.apple.com/documentation/uikit/uinavigationbar
        let openNavBar = self.navigationController!.navigationBar
        
        // https://developer.apple.com/documentation/uikit/uinavigationcontroller/customizing_your_app_s_navigation_bar
        let openNavBarAppearance = UINavigationBarAppearance()
        openNavBarAppearance.backgroundColor = UIColor.systemRed
        openNavBar.scrollEdgeAppearance = openNavBarAppearance
        // The navigation bar should prefer “large titles”. The title of the navigation bar above each issue view controller should be "Open Issues" or "Closed Issues", matching the name of the tab.
        openNavBar.prefersLargeTitles = true
        
        // Format the date
        // https://stackoverflow.com/questions/35700281/date-format-in-swift
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFormatterDisplay = DateFormatter()
        dateFormatterDisplay.dateFormat = "MMMM dd, yyyy"
        
        // "Pull-to-Refresh" functionality
        // https://developer.apple.com/documentation/uikit/uirefreshcontrol
        let refreshControl = UIRefreshControl()
        // https://www.hackingwithswift.com/articles/113/nsattributedstring-by-example
        let attr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let refreshTitle = NSAttributedString(string: "Pull to refresh open issues 🧑🏼‍💻", attributes: attr)
        refreshControl.attributedTitle = refreshTitle
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        // Our custom class function
        GitHubClient.fetchIssues(
            state: "open",
            completion: {(issues, error) in
                // Error handling
                guard let issues = issues, error == nil else {
                    print(error!)
                    return
                }
                for issue in issues {
                    if let title = issue.title, let date = dateFormatter.date(from: issue.createdAt),
                       let body = issue.body {
                        self.openIssues.append(Issue(title: title, createdAt: dateFormatterDisplay.string(from: date), body: body, user: "@"+issue.user.login))
                    }
                }
                self.tableView.reloadData()
            }
        )
    }
    
    // Associate with refreshControl.addTarget() action
    // https://cocoacasts.com/how-to-add-pull-to-refresh-to-a-table-view-or-collection-view
    @objc func refresh(sender: UIRefreshControl) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFormatterDisplay = DateFormatter()
        dateFormatterDisplay.dateFormat = "MMMM dd, yyyy"
            
        GitHubClient.fetchIssues(
            state: "open",
            completion: {(issues, error) in
                // Error handling
                guard let issues = issues, error == nil else {
                    print(error!)
                    return
                }
                for issue in issues {
                    if let title = issue.title, let date = dateFormatter.date(from: issue.createdAt),
                       let body = issue.body {
                        self.openIssues.append(Issue(title: title, createdAt: dateFormatterDisplay.string(from: date), body: body, user: "@"+issue.user.login))
                    }
                }
                self.tableView.reloadData()
            }
        )
        sender.endRefreshing()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openIssues.count
    }
    
    // How to register a cell for UITableViewCell reuse
    // https://www.hackingwithswift.com/example-code/uikit/how-to-register-a-cell-for-uitableviewcell-reuse
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let openCell = tableView.dequeueReusableCell(withIdentifier: "OpenCell", for: indexPath) as! IssueTableViewCell
        openCell.myOpenIssueTitle.text = openIssues[indexPath.row].title
        openCell.myOpenIssueUser.text =  openIssues[indexPath.row].user
        openCell.myOpenIssueTitle.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        openCell.myOpenIssueUser.textColor = UIColor.gray
        return openCell
    }
            
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // https://developer.apple.com/documentation/uikit/uiviewcontroller/1621490-prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let indexPath = tableView.indexPathForSelectedRow {
            let detailViewController = segue.destination as! IssueDetailViewController
            detailViewController.issueType = "open"
            detailViewController.passInData = openIssues[indexPath.row]
        }
    }
}
