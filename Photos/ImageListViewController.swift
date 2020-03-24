//
//  ListViewController.swift
//  Photos
//
//  Created by Krithika Iyer 2 on 25/03/20.
//  Copyright © 2020 kapil. All rights reserved.
//

import UIKit

class ImageListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var listData: [Item] = []
    let pendingOperations = PendingOperations()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterVsiew = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        self.tableView.register(UINib(nibName: "ImageListTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageListTableViewCell")
    }
    
    func startOperations(for photoRecord: Item, at indexPath: IndexPath) {
      switch (photoRecord.state) {
      case .new:
        startDownload(for: photoRecord, at: indexPath)
      default:
        NSLog("do nothing")
      }
    }
    
    func startDownload(for photoRecord: Item, at indexPath: IndexPath) {
      guard pendingOperations.downloadsInProgress[indexPath] == nil else {
        return
      }
      
      let downloader = ImageDownloader(photoRecord)
      downloader.completionBlock = {
        if downloader.isCancelled {
          return
        }
        
        DispatchQueue.main.async {
          self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
          self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
      }
      
      pendingOperations.downloadsInProgress[indexPath] = downloader
      
      pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func suspendAllOperations() {
      pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
      pendingOperations.downloadQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells() {
      if let pathsArray = tableView.indexPathsForVisibleRows {
        
        let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
        
        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(pathsArray)
        toBeCancelled.subtract(visiblePaths)
        
        
        var toBeStarted = visiblePaths
        toBeStarted.subtract(allPendingOperations)
        
        
        for indexPath in toBeCancelled {
          if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
            pendingDownload.cancel()
          }
          
          pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
        }
        
        for indexPath in toBeStarted {
          let recordToProcess = listData[indexPath.row]
          startOperations(for: recordToProcess, at: indexPath)
        }
      }
    }
    
    func showMessage(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style{
              case .default:
                self.navigationController?.popViewController(animated: true)

              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")


              @unknown default:
                print("unknown")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listData.count == 0 {
            showMessage(message: "No result found")
        }
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageListTableViewCell", for: indexPath) as! ImageListTableViewCell
        
        if cell.accessoryView == nil {
            let indicator = UIActivityIndicatorView(style: .medium)
            cell.accessoryView = indicator
        }
        let indicator = cell.accessoryView as! UIActivityIndicatorView
        let photoDetails = listData[indexPath.row]
        cell.selectionStyle = .none
        cell.pictureLabel.text = photoDetails.title
        cell.picture.image = photoDetails.image
        
        switch (photoDetails.state) {
        case .failed:
            indicator.stopAnimating()
            cell.pictureLabel.text = "Failed to load"
            
        case .new:
            indicator.startAnimating()
            if !tableView.isDragging && !tableView.isDecelerating {
                startOperations(for: photoDetails, at: indexPath)
            }
        case .downloaded:
            indicator.stopAnimating()
        }
        return cell
    }
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoDetail = listData[indexPath.row]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        vc.imageData = photoDetail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      if !decelerate {
        loadImagesForOnscreenCells()
        resumeAllOperations()
      }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      loadImagesForOnscreenCells()
      resumeAllOperations()
    }
}
