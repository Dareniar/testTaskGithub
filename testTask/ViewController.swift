//
//  ViewController.swift
//  testTask
//
//  Created by Danil Shchegol on 8/3/19.
//  Copyright © 2019 Danil Shchegol. All rights reserved.
//

import UIKit
import RealmSwift

final class MainViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var alphabetTableView: UITableView!
    @IBOutlet weak var starsTableView: UITableView!
    
    private var alphabetRepos: Results<Repository>?
    private var starsRepos: Results<Repository>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        alphabetTableView.delegate = self
        alphabetTableView.dataSource = self
        
        starsTableView.dataSource = self
        starsTableView.delegate = self
        
        updateDataSource()
    }
    
    private func updateDataSource() {
        let repos = RealmManager.default.objects(Repository.self)
        alphabetRepos = repos.filter("sortedByPopularity == false").sorted(byKeyPath: "name")
        starsRepos = repos.filter("sortedByPopularity == true")
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case alphabetTableView: return alphabetRepos?.count ?? 0
        case starsTableView: return starsRepos?.count ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell") as! RepositoryTableViewCell
        switch tableView {
        case alphabetTableView:
            if indexPath.row < alphabetRepos?.count ?? 0 {
                cell.configure(with: alphabetRepos?[indexPath.row])
            }
        case starsTableView:
            if indexPath.row < starsRepos?.count ?? 0 {
                cell.configure(with: starsRepos?[indexPath.row])
            }
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == alphabetTableView {
            guard let url = URL(string: alphabetRepos?[indexPath.row].repURL ?? "") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            guard let url = URL(string: starsRepos?[indexPath.row].repURL ?? "") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        RealmManager.default.beginWrite()
        RealmManager.default.deleteAll()
        try! RealmManager.default.commitWrite()
        NetworkingManager.shared.searchRepositories(query: searchBar.text ?? "", byPopularity: true) { _ in
            self.updateDataSource()
            self.starsTableView.reloadData()
        }
        NetworkingManager.shared.searchRepositories(query: searchBar.text ?? "", byPopularity: false) { _ in
            self.updateDataSource()
            self.alphabetTableView.reloadData()
        }
    }
}

