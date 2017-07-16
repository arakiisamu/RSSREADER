//
//  ViewController.swift
//  RSSREADER
//
//  Created by araki isamu on 2016/05/14.
//  Copyright © 2016年 araki isamu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {

    let feedUrl : URL? = URL(string: "http://b.hatena.ne.jp/hotentry/it.rss")
    
    @IBOutlet var tableView: UITableView!
    
    var items : [Item] = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let unfeedUrl = feedUrl {
            let parser : XMLParser? = XMLParser(contentsOf: unfeedUrl)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        UIApplication.shared.open(URL(string: item.url!)!, options: [:], completionHandler: nil)
    }
    
    
    var currentElementName : String?
    
    let itemElementName = "item"
    let titleElementName = "title"
    let linkElementName   = "link"
    
    func parserDidStartDocument(_ parser: XMLParser) {
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = nil
        if elementName == itemElementName {
            items.append(Item())
        } else {
            currentElementName = elementName
        }
    }
    
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
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
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElementName = nil;
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }

    class Item {
        var title : String?
        var url : String?
    }
}

