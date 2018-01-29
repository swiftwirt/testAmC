 //
//  MTMainViewController.swift
//  MaxTest
//
//  Created by Dmitry Ivashin on 1/26/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import CoreData

class MTMainViewController: UITableViewController {
    
    enum CellIdentifier {
        static let articleCell = "ArticleCell"
    }
    
    enum SegueIdentifier {
        static let toDetails = "SegueToDetails"
    }
    
    fileprivate let applicationManager = MTApplicationManager.instance()
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch()
    }
    
    fileprivate func performFetch()
    {
        fetchedResultsController = MTApplicationManager.instance().apiService.coreDataService.getFetchResultsController()
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    // Data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.articleCell, for: indexPath) as! MTArticleCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print(destinationIndexPath)
    }
    
    func configureCell(cell: MTArticleCell, indexPath: IndexPath) {
        let article = fetchedResultsController?.object(at: indexPath) as! Article
        cell.article = article
    }
    
    // Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case SegueIdentifier.toDetails:
            guard let controller = segue.destination as? MTDetailsViewController, let cell = sender as? MTArticleCell else { return }
            let detailsHTML = cell.article.contentDetailsHTML
            controller.htmlString = detailsHTML
        default:
            break
        }
    }
    
    @IBAction func onPullToRefresh(_ sender: Any) {
        applicationManager.articleService.uploadArticles() { [weak self] in
            performOnMainAsync {
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    deinit {
        fetchedResultsController?.delegate = nil
    }
}

extension MTMainViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            print(indexPath!)
            let cell = tableView.cellForRow(at: indexPath!) as! MTArticleCell
            configureCell(cell: cell, indexPath: indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                    atIndex sectionIndex: Int,
                    forChangeType type: NSFetchedResultsChangeType) {
        
        let indexSet = NSIndexSet(index: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet as IndexSet,
                                     with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet as IndexSet,
                                     with: .automatic)
        default :
            break
        }
    }
}
