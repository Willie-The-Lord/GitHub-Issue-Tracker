//
//  ClosedIssueTableViewController.swift
//  Project3-1
//
//  Created by Sung-Jie Hung on 2023/1/23.
//

import UIKit

class ClosedIssueTableViewController: UITableViewController {
    var closedIssues = [Issue]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize the color of your UINavigationBar using UINavigationBarAppearance() to be red for open issues and green for closed issues.
        // https://www.hackingwithswift.com/example-code/uikit/how-to-enable-large-titles-in-your-navigation-bar
        let closedNavBar = self.navigationController!.navigationBar
        let closedIssueAppearance = UINavigationBarAppearance()
        closedIssueAppearance.backgroundColor = UIColor.systemGreen
        closedNavBar.scrollEdgeAppearance = closedIssueAppearance
        closedNavBar.prefersLargeTitles = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFormatterDisplay = DateFormatter()
        dateFormatterDisplay.dateFormat = "MMMM dd, yyyy"
        
        // "Pull-to-Refresh" functionality
        let refreshControl = UIRefreshControl()
        let attr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let refreshTitle = NSAttributedString(string: "Pull to refresh open issues 🧑🏼‍💻", attributes: attr)
        refreshControl.attributedTitle = refreshTitle
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl

        GitHubClient.fetchIssues(
            state: "closed",
            completion: {(issues, error) in
                guard let issues = issues, error == nil else {
                    print(error!)
                    return
                }
                for issue in issues {
                    if let title = issue.title, let date = dateFormatter.date(from: issue.createdAt),
                       let body = issue.body {
                        self.closedIssues.append(Issue(title: title, createdAt: dateFormatterDisplay.string(from: date), body: body, user: "@"+issue.user.login))
                    }
                }
                self.tableView.reloadData()
            }
        )
    }

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
                        self.closedIssues.append(Issue(title: title, createdAt: dateFormatterDisplay.string(from: date), body: body, user: "@"+issue.user.login))
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
        return closedIssues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClosedCell", for: indexPath) as! IssueTableViewCell
        cell.myClosedIssueTitle.text = closedIssues[indexPath.row].title
        cell.myClosedIssueUser.text =  closedIssues[indexPath.row].user
        cell.myClosedIssueTitle.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        cell.myClosedIssueUser.textColor = UIColor.gray

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let detailViewController = segue.destination as! IssueDetailViewController
            detailViewController.passInData = closedIssues[indexPath.row]
            detailViewController.issueType = "closed"
        }
    }
}
