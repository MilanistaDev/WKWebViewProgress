//
//  NewKVOAPIViewController.swift
//  WKWebViewProgress
//
//  Created by 麻生 拓弥 on 2017/12/15.
//  Copyright © 2017年 麻生 拓弥. All rights reserved.
//

import UIKit
import WebKit

class NewKVOAPIViewController: UIViewController {

    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    var progressView = UIProgressView()
    var observeEstimatedProgress: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpWebView()
        self.setUpUI()
        self.sendRequest()
    }

    deinit {
        self.wkWebView.navigationDelegate = nil
        self.wkWebView.uiDelegate = nil
        self.progressView.alpha = 0.0
    }

    // MARK: - Private method

    func setUpWebView() {
        self.wkWebView.navigationDelegate = self
        self.wkWebView.uiDelegate = self
    }

    func setUpUI() {
        self.progressView = UIProgressView(frame: CGRect(x: 0.0,
                                                         y: (self.navigationController?.navigationBar.frame.size.height)! - 3.0,
                                                         width: self.view.frame.size.width,
                                                         height: 3.0))
        self.progressView.progressViewStyle = .bar
        self.navigationController?.navigationBar.addSubview(self.progressView)

        self.navigationItem.title = "WKWebView"
        if #available(iOS 11.0, *) {
            self.topLayoutConstraint.constant = 0.0
        } else {
            self.topLayoutConstraint.constant = -64.0
        }

        // New API for KVO
        self.observeKeysFowWebView()
    }

    func sendRequest() {
        // URLリクエスト
        let url = URL(string: "https://www.yumemi.co.jp")
        self.wkWebView.load(URLRequest(url: url!, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10.0))
    }

    func observeKeysFowWebView() {

        self.observeEstimatedProgress = self.wkWebView.observe(\.estimatedProgress, options: [.new], changeHandler: { (webView, change) in
            self.progressView.alpha = 1.0
            // estimatedProgressが変更されたときにプログレスバーの値を変更
            self.progressView.setProgress(Float(change.newValue!), animated: true)

            if (self.wkWebView.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.3,
                               delay: 0.3,
                               options: [.curveEaseOut],
                               animations: { [weak self] in
                                self?.progressView.alpha = 0.0
                    }, completion: { _ in
                        self.progressView.setProgress(0.0, animated: false)
                })
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension NewKVOAPIViewController: WKNavigationDelegate {

}

extension NewKVOAPIViewController: WKUIDelegate {

}
