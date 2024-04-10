//
//  HomeViewController.swift
//  GitHubApiUsage
//
//  Created by Admin on 09/04/24.
//

import UIKit

class HomeViewController: UIViewController {

    let options = ViewPagerOptions()
    var tabs = [ ViewPagerTab(title: "Open", image:nil),
                 ViewPagerTab(title: "Closed", image: nil)]
    var pager:ViewPager?

    override func viewDidLoad() {
        super.viewDidLoad()

        configTabs()

        // Do any additional setup after loading the view.
    }
    
    func configTabs(){
        options.tabType = .basic
        options.distribution = .segmented
        options.tabViewBackgroundDefaultColor = .white
        options.tabViewBackgroundHighlightColor = .white
        options.tabViewTextDefaultColor = .gray
        options.tabViewTextHighlightColor = .black
        pager = ViewPager(viewController: self)
        pager?.setOptions(options: options)
        pager?.setDataSource(dataSource: self)
        pager?.setDelegate(delegate: self)
        pager?.build()
    }
    
}

extension HomeViewController: ViewPagerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "GitHubApiViewController") as! GitHubApiViewController
        vc.state = position == 0 ? .open : .closed
        return vc
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
}

extension HomeViewController: ViewPagerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
    }
}

