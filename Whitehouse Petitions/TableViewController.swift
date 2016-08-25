//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by Ethan Thomas on 8/23/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import UIKit
import SwiftyJSON
import SafariServices

class TableViewController: UITableViewController {
    
    var objects = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Petitions 📝"
        tableView.delegate = self
        tableView.dataSource = self
        let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                    parseJSON(json: json)
                } else {
                    showAlert(title: "Error!", message: "Government API (webservice) seems to be down.")
                }
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac, animated: true, completion: nil)
    }
    
    func parseJSON(json: JSON) {
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let signatureCount = result["signatureCount"].stringValue
            let url = result["url"].stringValue
            
            let obj = ["title": title, "body": body, "signatureCount": signatureCount, "url": url]
            
            objects.append(obj)
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension TableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let object = objects[indexPath.row]
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel!.text = object["body"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = objects[indexPath.row]
        
        if let urlString = object["url"] {
            if let url = URL.init(string: urlString) {
                let safariController = SFSafariViewController.init(url: url, entersReaderIfAvailable: true)
                present(safariController, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
}

