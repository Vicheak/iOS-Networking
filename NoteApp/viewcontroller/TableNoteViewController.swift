//
//  TableNoteViewController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 27/6/24.
//

import UIKit
import SnapKit
import CoreData

class TableNoteViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    lazy var titleLabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 18)
        return titleLabel
    }()
    lazy var detailLabel = {
        let detailLabel = UILabel()
        detailLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        return detailLabel
    }()
    var tableView = UITableView();
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let context = CoreDataManager.shared.context
        
        // Create a fetch request and sort descriptor for the entity to display
        // in the table view.
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        // filter from folder
        fetchRequest.predicate = NSPredicate(format: "folder = %@", folder)

        // Initialize the fetched results controller with the fetch request and
        // managed object context.
        return NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }()
    
    var folder: Folder!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = .white;
        hidesBottomBarWhenPushed = true
        navigationItem.title = "Note List - Folder, \(folder.name!)"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.rectangle.on.rectangle"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        setUpView();
        
        titleLabel.text = "Folder Name : \(folder.name!)"
        detailLabel.text = "Folder Detail : \(folder.detail!)"
        
        tableView.keyboardDismissMode = .onDrag
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "prototype")
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchedResultsController.delegate = self
        
        // Perform a fetch.
        try? fetchedResultsController.performFetch()
    }
    
    private func setUpView(){
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        view.addSubview(tableView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-5)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-5)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(40)
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        tableView.layoutIfNeeded()
    }
    
    @objc func rightBarButtonTapped(sender: UIBarButtonItem){
        let createNoteViewController = CreateNoteViewController()
        createNoteViewController.folder = folder
        createNoteViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(createNoteViewController, animated: true)
    }
    
}

extension TableNoteViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText.isEmpty {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "folder = %@", folder)
        } else {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "title = %@ AND folder = %@", searchText, folder)
        }
        try? fetchedResultsController.performFetch()
        tableView.reloadData()
    }
    
}

extension TableNoteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath) as? NoteTableViewCell else { return UITableViewCell() }
        
        let note = fetchedResultsController.object(at: indexPath)
        
        cell.titleLabel.text = note.title
        cell.detailLabel.text = note.detail
        return cell
    }
    
}

extension TableNoteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, complete in
            guard let self = self else { return}
            let alertController = UIAlertController(title: "Confirmation", message: "Are you sure to remove?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "OK", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                
                let note = fetchedResultsController.object(at: indexPath)
                
                CoreDataManager.shared.context.delete(note)
                
                do {
                    try CoreDataManager.shared.save()
                }  catch {
                    print("error : \(error)")
                }
            }
            let noAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                complete(true)
            }
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            present(alertController, animated: true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, complete in
            guard let self = self else { return }
            
            let note = fetchedResultsController.object(at: indexPath)
            
            let editNoteViewController = EditNoteViewController()
            editNoteViewController.note = note
            editNoteViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(editNoteViewController, animated: true)
            
            complete(true)
        }
    
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
}

extension TableNoteViewController: NSFetchedResultsControllerDelegate {
    
    // Find out when the fetched results controller is about to start making changes.
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Start animating table view changes simultaneously.
        tableView.beginUpdates()
    }

    // Find out when the fetched results controller finishes making changes.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Stop animating table view changes simultaneously.
        tableView.endUpdates()
    }

    // Find out when the fetched results controller adds or removes a section.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            // Insert a new section with fade animation.
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            // Delete a section with fade animation.
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break
        }
    }

    // Find out when the fetched results controller adds, removes, moves, or
    // updates a fetched object.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath else { return }
            // Insert a new row with fade animation when the fetched results
            // controller adds or moves an object to the specified index path.
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath else { return }
            // Delete the row with animation at the old index path when the fetched
            // results controller deletes or moves the associated object.
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath else { return }
            // Update the cell as the specified indexPath.
            if let cell = tableView.cellForRow(at: indexPath) {
                let noteTableViewCell = cell as! NoteTableViewCell
                noteTableViewCell.titleLabel.text = fetchedResultsController.object(at: indexPath).title
                noteTableViewCell.detailLabel.text = fetchedResultsController.object(at: indexPath).detail
            }
        case .move:
            guard let indexPath, let newIndexPath else { return }
            // Move a row from the specified index path to the new index path.
            tableView.moveRow(at: indexPath, to: newIndexPath)
            if let cell = tableView.cellForRow(at: indexPath) {
                let noteTableViewCell = cell as! NoteTableViewCell
                noteTableViewCell.titleLabel.text = fetchedResultsController.object(at: newIndexPath).title
                noteTableViewCell.detailLabel.text = fetchedResultsController.object(at: newIndexPath).detail
            }
        @unknown default:
            break
        }
    }
    
}