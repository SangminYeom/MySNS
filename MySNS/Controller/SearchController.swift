import UIKit

class SearchController: UITableViewController {
    
    private let reuseIdentifier = "UserCell"
    
    // MARK: - Properties
    private var users = [User]()
    private var filterUsers = [User]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
     
        configureTableView()
        fetchUsers()
        configureSarchController()
    }
    
    // MARK: - APIs
    func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    // MARK: - helpers
    func configureTableView() {
        view.backgroundColor = .white
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }
    
    func configureSarchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

// MARK: - UITableViewDataSource
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filterUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        let user = isSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        
        // view model 설정
        cell.viewModel = UserCellViewModel(user: user)
        
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ProfileController(user: users[indexPath.row])
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - SearchController protocol
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filterUsers = users.filter({
            $0.username.contains(searchText) ||
            $0.fullname.lowercased().contains(searchText)
        })
        
        self.tableView.reloadData()
    }
}
