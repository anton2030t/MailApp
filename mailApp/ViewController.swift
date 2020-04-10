//
//  ViewController.swift
//  mailApp
//
//  Created by Антон Ларченко on 06.09.2019.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let idCell = "mailCell"
    var model = MailModel()
    var refreshControl = UIRefreshControl()
    var search = UISearchController()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //tableView.isEditing = true
        search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        
        let btnSettings = UIBarButtonItem(title: "Настройки", style: .plain, target: self, action: #selector(goToSettings))
        navigationItem.rightBarButtonItem = btnSettings
        
        let btnAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMessage))
        navigationItem.leftBarButtonItem = btnAdd
        refreshControl.tintColor = .red
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление")
        refreshControl.addTarget(self, action: #selector(updateTable), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    @objc func updateTable() {
        self.model.addNewMessage()
        self.model.addNewMessage()
        self.model.addNewMessage()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func addMessage() {
        tableView.performBatchUpdates({
            self.model.addNewMessage()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }) { (result) in
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    @objc func goToSettings() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeRead = UIContextualAction(style: .normal, title: "Непрочитанное") { (action, view, success) in
            print("NoReadSwipe")
        }
        swipeRead.image = UIImage(systemName: "envelope")
        swipeRead.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return UISwipeActionsConfiguration(actions: [swipeRead])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeMore = UIContextualAction(style: .normal, title: "Ещё") { (action, view, success) in
            print("More")
        }
        swipeMore.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        swipeMore.image = UIImage(systemName: "ellipsis")
        
        let swipeFlag = UIContextualAction(style: .normal, title: "Флаг") { (action, view, success) in
            print("Flag")
        }
        swipeFlag.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        swipeFlag.image = UIImage(systemName: "flag")
        
        let swipeArchive = UIContextualAction(style: .normal, title: "Архив") { (action, view, success) in
            self.tableView.performBatchUpdates({
                self.model.removeMessage(indexPath: indexPath)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                success(true)
            }, completion: nil)
        }
        swipeArchive.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        swipeArchive.image = UIImage(systemName: "archivebox")
        
        let conf = UISwipeActionsConfiguration(actions: [swipeArchive, swipeFlag, swipeMore])
        conf.performsFirstActionWithFullSwipe = false
        
        return conf
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch() {
            return model.filteredMessages.count
        }
        return model.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as! MailTableViewCell
        var message: Message
        if isSearch() {
            message = model.filteredMessages[indexPath.row]
        } else {
            message = model.messages[indexPath.row]
        }
        cell.fromLabel.text = message.name
        cell.subjectLabel.text = message.subject
        cell.textMessageLabel.text = message.text
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("Details\(indexPath.row)")
    }
    
    func searchBarIsEmpty() -> Bool {
        return search.searchBar.text?.isEmpty ?? true
    }
    
    func isSearch() -> Bool {
        return search.isActive && !searchBarIsEmpty()
    }
    
    func searchMessagesFilter(text: String) {
        model.messagesFilter(text: text)
        tableView.reloadData()
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchMessagesFilter(text: searchController.searchBar.text!)
    }
}
