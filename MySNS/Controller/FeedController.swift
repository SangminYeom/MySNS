//
//  FeedController.swift
//  MySNS
//
//  Created by SANGMIN YEOM on 2022/01/13.
//

import UIKit
import Firebase

private let reuseIdentifier = "cell"
class FeedController: UICollectionViewController {
    
    // MARK: - properties
    private var posts = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // profile controller에서 이미지 선택했을 때 단일 post 설정
    var post: Post?
    
    // MARK: - lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchPosts()
    }
    
    // MARK: - actions
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            
            controller.delegate = self.tabBarController as? MainTabController
            
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchPosts()
    }
    
    // MARK: - apis
    func fetchPosts() {
        
        guard post == nil else { return }
        
        PostService.fetchPosts { posts in
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.checkIfUserLikedPosts()
            self.collectionView.reloadData()
        }
    }
    
    func checkIfUserLikedPosts() {
        self.posts.forEach { post in
            PostService.checkIfUserLikedPost(post: post) { didLike in
                if let index = self.posts.firstIndex(where: { $0.postId == post.postId }) {
                    self.posts[index].didLike = didLike
                }
            }
        }
    }
    
    // MARK: - helpers
    func configureUI() {
        collectionView.backgroundColor = .white
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                               style: UIBarButtonItem.Style.plain,
                                                               target: self,
                                                               action: #selector(handleLogout))
        }
        
        navigationItem.title = "Feed"
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
        collectionView.refreshControl = refresher
    }
}

// MARK: - UICollectionViewDataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? self.posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        
        cell.delegate = self
        
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 110
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - FeedCellDelegate
extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        cell.viewModel?.post.didLike.toggle()
        if post.didLike {
            PostService.unlikePost(post: post) { _ in
                cell.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        } else {
            PostService.likePost(post: post) { error in
                cell.likeButton.setImage(UIImage(named: "like_selected"), for: UIControl.State.normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
            }
        }
    }
}

