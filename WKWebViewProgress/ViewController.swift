//
//  ViewController.swift
//  WKWebViewProgress
//
//  Created by 麻生 拓弥 on 2017/10/17.
//  Copyright © 2017年 麻生 拓弥. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    var progressView = UIProgressView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "WKWebView"
        // NavigationBar の下にUIprogressViewをBar形式で配置
        self.progressView = UIProgressView(frame: CGRect(x: 0.0, y: (self.navigationController?.navigationBar.frame.size.height)! - 3.0, width: self.view.frame.size.width, height: 3.0))
        self.progressView.progressViewStyle = .bar
        self.navigationController?.navigationBar.addSubview(self.progressView)

        if #available(iOS 11.0, *) {
            self.topLayoutConstraint.constant = 0.0
        } else {
            self.topLayoutConstraint.constant = -64.0
        }

        self.wkWebView.navigationDelegate = self
        self.wkWebView.uiDelegate = self

        // KVO 監視
        self.wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

        // URLリクエスト
        let url = URL(string: "https://www.yumemi.co.jp")
        self.wkWebView.load(URLRequest(url: url!, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10.0))
    }

    deinit {
        self.wkWebView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
    }

    /// 監視しているWKWebViewのestimatedProgressの値をUIProgressViewに反映
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if (keyPath == "estimatedProgress") {
            // alphaを1にする(表示)
            self.progressView.alpha = 1.0
            // estimatedProgressが変更されたときにプログレスバーの値を変更
            self.progressView.setProgress(Float(self.wkWebView.estimatedProgress), animated: true)

            // estimatedProgressが1.0になったらアニメーションを使って非表示にしアニメーション完了時0.0をセットする
            if (self.wkWebView.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.3,
                               delay: 0.3,
                               options: [.curveEaseOut],
                               animations: { [weak self] in
                                self?.progressView.alpha = 0.0
                    }, completion: {
                        (finished : Bool) in
                        self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: WKNavigationDelegate {

}

extension ViewController: WKUIDelegate {

}

