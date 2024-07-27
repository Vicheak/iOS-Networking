//
//  HomeViewController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 26/6/24.
//

import UIKit
import SnapKit
import CoreData
import KeychainSwift

class HomeViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var titleLabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let context = CoreDataManager.shared.context
        
        // Create a fetch request and sort descriptor for the entity to display
        // in the table view.
        let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        // Initialize the fetched results controller with the fetch request and
        // managed object context.
        return NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }()
    
    //search not found view
    var searchView = UIView()
    lazy var searchStackView  = {
        let searchStackView = UIStackView()
        searchStackView.axis = .vertical
        searchStackView.distribution = .fill
        searchStackView.alignment = .fill
        searchStackView.spacing = 20
        searchStackView.contentMode = .scaleToFill
        return searchStackView
    }()
    var bottomConstraint: Constraint!
    lazy var searchImageView = {
        let searchImageView = UIImageView()
        searchImageView.contentMode = .scaleAspectFit
        searchImageView.tintColor = .folderColor
        
        guard let searchIcon = UIImage(named: "search-not-found-icon") else {
            searchImageView.image = UIImage(systemName: "mail.and.text.magnifyingglass")
            return searchImageView
        }
        searchImageView.image = searchIcon
        
        return searchImageView
    }()
    var searchTitleLabel = {
        let searchTitleLabel = UILabel()
        searchTitleLabel.text = "Search not found!"
        searchTitleLabel.textAlignment = .center
        searchTitleLabel.numberOfLines = 0
        return searchTitleLabel
    }()
    var keyboardUtil: KeyboardUtil!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Home"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        setUpDefaultView()
        setUpView()
        setUpSearchView()
        
        toggleSearchView(enable: false, searchText: "")
        
        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        collectionView.keyboardDismissMode = .onDrag
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FolderCollectionViewCell.self, forCellWithReuseIdentifier: "prototype")
        
        NotificationCenter.default.addObserver(self, selector: #selector(createFolder), name: NSNotification.Name.saveFolder, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editFolder), name: NSNotification.Name.editFolder, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteFolder), name: NSNotification.Name.deleteFolder, object: nil)

        // Perform a fetch.
        try? fetchedResultsController.performFetch()
        checkHomeView()
        
        //test access token
//        let keychain = KeychainSwift()
//        let accessToken = keychain.get("accessToken")
//        print("Access token : \(accessToken)")
    }
    
    override func viewWillAppear(_ animate: Bool){
        super.viewWillAppear(animate)
        collectionView.reloadData()
    }
    
    private func setUpView(){
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchView.isHidden = true
    }
    
    private func setUpDefaultView(){
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setUpSearchView(){
        view.addSubview(searchView)
        searchView.addSubview(searchStackView)
        searchStackView.addArrangedSubview(searchImageView)
        searchStackView.addArrangedSubview(searchTitleLabel)
        
        searchView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            bottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).constraint
        }
        
        searchStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().offset(0)
            make.leading.equalToSuperview().offset(40)
            make.bottom.lessThanOrEqualToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-40)
            make.centerX.centerY.equalToSuperview()
        }
        
        searchImageView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
    }
    
    private func checkHomeView(){
        if fetchedResultsController.fetchedObjects?.isEmpty ?? true  {
            titleLabel.text = "No folder's information"
            titleLabel.isHidden = false
            collectionView.isHidden = true
        }else {
            titleLabel.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    private func toggleSearchView(enable: Bool, searchText: String){
        if !titleLabel.isHidden {
            return
        }
        collectionView.isHidden = enable
        searchView.isHidden = !enable
        searchTitleLabel.text = "Search not found \"\(searchText)\""
    }

    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func rightBarButtonTapped(sender: UIBarButtonItem){
        let createFolderViewController = CreateFolderViewController()
        createFolderViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(createFolderViewController, animated: true)
    }

}

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText.isEmpty {
            fetchedResultsController.fetchRequest.predicate = nil
        } else {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
        }
        try? fetchedResultsController.performFetch()
        collectionView.reloadData()
        toggleSearchView(enable: fetchedResultsController.fetchedObjects?.isEmpty ?? true, searchText: searchText)
    }
    
}

extension HomeViewController {
    
    @objc func createFolder(notification: Notification){
        try? fetchedResultsController.performFetch()
        collectionView.reloadData()
        checkHomeView()
    }
    
    @objc func editFolder(notification: Notification){
        collectionView.reloadData()
    }
    
    @objc func deleteFolder(notification: Notification){
        try? fetchedResultsController.performFetch()
        collectionView.reloadData()
        checkHomeView()
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "prototype", for: indexPath) as? FolderCollectionViewCell else { return UICollectionViewCell() }
        
        let folder = fetchedResultsController.object(at: indexPath)
        
        collectionViewCell.titleLabel.text = folder.name
        collectionViewCell.numberOfNoteLabel.text = "note(\(folder.notes?.count ?? 0))"
        return collectionViewCell
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewCellEstimatedSize = (collectionView.frame.width - 10) / 4 - 5
        return CGSize(width: collectionViewCellEstimatedSize, height: collectionViewCellEstimatedSize + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.contentView.backgroundColor = .systemBackground
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                cell?.contentView.backgroundColor = .systemBackground
            }
        }
        
        let folder = fetchedResultsController.object(at: indexPath)
        
        let tableNoteViewController = TableNoteViewController()
        tableNoteViewController.folder = folder
        tableNoteViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(tableNoteViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let viewNoteAction = UIAction(title: "View Notes", image: UIImage(systemName: "eye.circle")) { [weak self] (action) in
                guard let self = self else { return }
                
                let folder = fetchedResultsController.object(at: indexPath)
                
                let tableNoteViewController = TableNoteViewController()
                tableNoteViewController.folder = folder
                tableNoteViewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(tableNoteViewController, animated: true)
            }
            let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { [weak self] (action) in
                guard let self = self else { return }
           
                let folder = fetchedResultsController.object(at: indexPath)
                
                let editViewController = EditFolderViewController()
                editViewController.folder = folder
                editViewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(editViewController, animated: true)
            }
            let yes = UIAction(title: "Yes", image: UIImage(systemName: "checkmark.circle")) { [weak self] (action) in
                guard let self = self else { return }
                
                let folder = fetchedResultsController.object(at: indexPath)
                
                CoreDataManager.shared.context.delete(folder)
                
                do {
                    try CoreDataManager.shared.save()
                }  catch {
                    print("error : \(error)")
                }
                
                NotificationCenter.default.post(name: NSNotification.Name.deleteFolder, object: nil)
            }
            let no = UIAction(title: "No", image: UIImage(systemName: "xmark.app")) { _ in }
            let deleteAction = UIMenu(title: "Delete", image: UIImage(systemName: "trash.square"), options: .destructive, children: [yes, no])
            return UIMenu(title: "Options", children: [viewNoteAction, editAction, deleteAction])
        }
    }
    
}
