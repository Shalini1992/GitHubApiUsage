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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        configureObservable()
        getIssues()

    }
    
    func getIssues(){
        Task.init {
            do{
                try await  gitHubApiViewModel.getIssues()
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

                
                self.tableView.reloadData()
               
            }
        }.store(in: &cancellable)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == tableView,
            (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height
            else { return }
        getIssues()
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

