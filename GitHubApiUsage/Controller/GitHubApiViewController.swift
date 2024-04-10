//
//  GitHubApiViewController.swift
//  GitHubApiUsage
//
//  Created by Admin on 09/04/24.
//

import UIKit
import Combine


class GitHubApiViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var state = IssuesState.open
    var gitHubApiViewModel:GitHubApiViewModel!
    var issues = [GitHubIssuesModel]()
    var cancellable = Set<AnyCancellable>()
    
    private let gitHubIssuesManager:GitHubIssuesManager = GitHubIssuesManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            configureObservable()
            getIssues()

        }else{
            print("Internet Connection not Available!")
            fetchissueFromLocalDB()

        }
        
    }
    
    func getIssues(){
        Task.init {
            do{
                try await  gitHubApiViewModel.getIssuesUsingNetworkManagerClass()
            }catch(let error){
                print(error)
            }
           
        }
    }
    
    func configureObservable() {
        gitHubApiViewModel = GitHubApiViewModel(state: self.state)
        gitHubApiViewModel.$issues.sink { [weak self] issues in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.issues = issues
                
                self.removeFromLocalDB()
                self.saveToLocalDB()
                
                self.tableView.reloadData()
               
            }
        }.store(in: &cancellable)
    }
    
    
    func removeFromLocalDB() {
        
        let githubissuesFromDB = gitHubIssuesManager.fetchGitHubIssues()

        githubissuesFromDB?.forEach({ gitHubModel in
           let deleteStatus = gitHubIssuesManager.deleteGitHubIssue(githubIssue: gitHubModel)
            
            debugPrint("deleteStatus is \(deleteStatus)")
        })
        
    }
    
    func saveToLocalDB() {
        
        for githubissue in self.issues {
            gitHubIssuesManager.createGithubIssue(githubIssue: githubissue)
        }
        
    }
    
    func fetchissueFromLocalDB() {
        
//        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        debugPrint(path[0])
        
        let filteredArray = gitHubIssuesManager.fetchGitHubIssues() ?? []
        self.issues =  filteredArray.filter({($0.state?.localizedCaseInsensitiveContains(state.rawValue))!})

        if(self.issues.count == 0){
            displayAlert()
        }
        debugPrint("githubissuesFromDB \(self.issues )")
        self.tableView.reloadData()

        
    }
    
    func displayAlert() {
        
        let message = "No offline " + state.rawValue + " issues"
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
                  
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                    //Cancel Action
                }))
             
                DispatchQueue.main.async {
                    self.present(alert, animated: false, completion: nil)
                }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == tableView,
            (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height
            else { return }
        if Reachability.isConnectedToNetwork(){
            getIssues()
        }
    }

}

extension GitHubApiViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "showDetails") as? ShowIssueDetailsViewController {
            if let navigator = navigationController {
                viewController.htmlString = issues[indexPath.row].body_html ?? ""
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
       
    }
    
}

extension GitHubApiViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomcellforIssues = tableView.dequeueReusableCell(withIdentifier: "customcellforIssues", for: indexPath) as! CustomcellforIssues
        
        cell.titleLbl.text = issues[indexPath.row].title ?? ""
        if(state == .open){
            cell.createdByLbl.text = "#" + "\(issues[indexPath.row].number ?? 0)" + "   " +  " \(state)ed on" + "   "  + "\(issues[indexPath.row].createdAt ?? "")" + "   " + "by" + "   " + (issues[indexPath.row].user?.login ?? "")
        }else {
            cell.createdByLbl.text = "#" + "\(issues[indexPath.row].number ?? 0)" + "   " +  " \(state) on" + "   "  + "\(issues[indexPath.row].createdAt ?? "")" + "   " + "by" + "   " + (issues[indexPath.row].user?.login ?? "")
        }
        return cell
    }
    
    
    
}

