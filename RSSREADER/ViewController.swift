//
//  ViewController.swift
//  RSSREADER
//
//  Created by araki isamu on 2016/05/14.
//  Copyright © 2016年 araki isamu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate {

    let feedUrl : NSURL? = NSURL(string: "http://b.hatena.ne.jp/hotentry/it.rss")
    
    @IBOutlet var tableView: UITableView!
    
    var items : [Item] = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let unfeedUrl = feedUrl {
            let parser : NSXMLParser? = NSXMLParser(contentsOfURL: unfeedUrl)
            if let unparser = parser {
                unparser.delegate = self;
                unparser.parse()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = items[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: item.url!)!)
    }
    
    
    var currentElementName : String?
    
    let itemElementName = "item"
    let titleElementName = "title"
    let linkElementName   = "link"
    
    func parserDidStartDocument(parser: NSXMLParser) {
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = nil
        if elementName == itemElementName {
            items.append(Item())
        } else {
            currentElementName = elementName
        }
    }
    
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if items.count > 0 {
            let lastItem = items[items.count-1]
            if let unCurrentElementName = currentElementName {
                if unCurrentElementName == titleElementName {
                    let tmpString : String? = lastItem.title
                    lastItem.title = (tmpString != nil) ? tmpString! + string : string
                } else if unCurrentElementName == linkElementName {
                    lastItem.url = string
                }
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElementName = nil;
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        self.tableView.reloadData()
    }

    class Item {
        var title : String?
        var url : String?
    }
}

