//
//  ShowIssueDetailsViewController.swift
//  GitHubApiUsage
//
//  Created by Admin on 09/04/24.
//

import UIKit
import WebKit

class ShowIssueDetailsViewController: UIViewController {

    var htmlString = String()

    @IBOutlet weak var wkwebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        wkwebView.navigationDelegate = self

        let htmlString:String! = "\(htmlString)"
        wkwebView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)

    }
    

}


extension ShowIssueDetailsViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
       debugPrint("didCommit")
   }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       debugPrint("didFinish")
        guard let path = Bundle.main.path(forResource: "style-ios", ofType: "css") else { return }
        let cssString = try! String(contentsOfFile: path).trimmingCharacters(in: .whitespacesAndNewlines)

        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"

        wkwebView.evaluateJavaScript(jsString, completionHandler: nil)
   }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       debugPrint("didFail")
   }
}


//extension ShowIssueDetailsViewController:UIWebViewDelegate {
//    
//    func webViewDidFinishLoad(_ webView: UIWebView){
//           let path = Bundle.main.path(forResource: "style-ios", ofType: "css")!
//
//           let javaScriptStr = "var link = document.createElement('link'); link.href = '\(path)'; link.rel = 'stylesheet'; document.head.appendChild(link)"
//           webview.stringByEvaluatingJavaScript(from: javaScriptStr)
//       }
//}
