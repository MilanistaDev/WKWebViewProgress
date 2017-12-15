//
//  TopViewController.swift
//  WKWebViewProgress
//
//  Created by 麻生 拓弥 on 2017/12/15.
//  Copyright © 2017年 麻生 拓弥. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {

    @IBOutlet weak var topTableView: UITableView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!

    private let itemArray: [String] = ["Swift 3.1 or before", "Swift 3.2 or later"]
    private let segueNameArray: [String] = ["normalKVOSegue", "newKVOAPISegue"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "WKWebView estimatedProgress test"
        if #available(iOS 11.0, *) {
            self.topLayoutConstraint.constant = 0.0
        } else {
            self.topLayoutConstraint.constant = -64.0
        }
        self.topTableView.delegate = self
        self.topTableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPathForSelectedRow = self.topTableView.indexPathForSelectedRow {
            self.topTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TopViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: self.segueNameArray[indexPath.row], sender: nil)
    }
}

extension TopViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell")
        cell?.textLabel?.text = self.itemArray[indexPath.row]
        return cell!
    }
}
