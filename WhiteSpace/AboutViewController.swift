//
//  AboutViewController.swift
//  WhiteSpace
//

import UIKit
import WebKit

class AboutViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backwardButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var openInSafariButton: UIBarButtonItem!
    
    let myGitHubURL = URL(string: "https://github.com/WANGJIEKE")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateToolBarUI()
        setNavigationItemRightBarButtonItemToStop()
        webView.load(URLRequest(url: myGitHubURL))
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    // MARK: - WKWebView
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            navigationItem.title = webView.title
            updateToolBarUI()
            
            if Float(webView.estimatedProgress) < 1.0 {
                setNavigationItemRightBarButtonItemToStop()
            } else {
                setNavigationItemRightBarButtonItemToRefresh()
            }
        }
    }
    
    func setNavigationItemRightBarButtonItemToStop() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .stop,
            target: self,
            action: #selector(stopWebView)
        )
    }
    
    func setNavigationItemRightBarButtonItemToRefresh() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshWebView)
        )
    }
    
    @objc func stopWebView() {
        webView.stopLoading()
    }
    
    @objc func refreshWebView() {
        webView.reload()
    }
    
    // MARK: - UIToolBar
    
    func updateToolBarUI() {
        backwardButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        shareButton.isEnabled = webView.url != nil
        openInSafariButton.isEnabled = webView.url != nil
    }
    
    @IBAction func onBackwardTapped(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func onForwardTapped(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func onShareTapped(_ sender: UIBarButtonItem) {
        guard let url = webView.url else { return }
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    @IBAction func onOpenInSafariTapped(_ sender: UIBarButtonItem) {
        guard let url = webView.url else { return }
        UIApplication.shared.open(url)
    }
}
