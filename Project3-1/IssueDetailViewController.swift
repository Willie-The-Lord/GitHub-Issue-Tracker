//
//  IssueDetailViewController.swift
//  Project3-1
//
//  Created by Sung-Jie Hung on 2023/1/23.
//

import UIKit

class IssueDetailViewController: UIViewController {
    // Pass Data using Seque
    // https://medium.com/a-developer-in-making/how-to-pass-data-using-segue-and-unwind-in-swift-afaf241186fc
    var passInData: Issue?
    var issueType: String?
    @IBOutlet var myTitle: UILabel!
    @IBOutlet var myAuthor: UILabel!
    @IBOutlet var myDate: UILabel!
    @IBOutlet var myDescription: UITextView!
    @IBOutlet var myImage: UIImageView!
    @IBOutlet var footerImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // https://stackoverflow.com/questions/31417853/swift-string-interpolation-displaying-optional
        myTitle.numberOfLines = 0
        myTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        myTitle.text = passInData?.title
        myTitle.font = UIFont(name:"HelveticaNeue-Bold", size: 25.0)
        
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        let attrs2 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        
        let boldText = "Author: "
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        let normalText = "\(passInData?.user ?? "")"
        let normalString = NSMutableAttributedString(string:normalText, attributes: attrs2)
        attributedString.append(normalString)
        myAuthor.attributedText = attributedString
//        myAuthor.font = UIFont(name:"HelveticaNeue", size: 20.0)
        
        let boldText2 = "Date: "
        let attributedString2 = NSMutableAttributedString(string:boldText2, attributes:attrs)
        let normalText2 = "\(passInData?.createdAt ?? "")"
        let normalString2 = NSMutableAttributedString(string:normalText2, attributes: attrs2)
        attributedString2.append(normalString2)
        myDate.attributedText = attributedString2
//        myDate.font = UIFont(name:"HelveticaNeue", size: 20.0)
        
        // https://stackoverflow.com/questions/2647164/bordered-uitextview
        myDescription.text = passInData?.body
        myDescription.layer.borderWidth = 5.0
        myDescription.layer.cornerRadius = 10
//        myDescription.backgroundColor = UIColor.lightGray
        
        if let type = issueType {
            if type == "open" {
                myImage.image = UIImage(systemName: "envelope.open")
                myImage.tintColor = UIColor.systemRed
            } else {
                myImage.image = UIImage(systemName: "envelope")
                myImage.tintColor = UIColor.systemGreen
            }
        }
        footerImage.image = UIImage(named: "github")
    }
}
