//
//  HotelListViewController.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 10/03/2022.
//

import UIKit

class HotelListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBarAppearance()
        setUpSearchBar()
        title = "Dubai, United Arab Emirates"
    }
    
    func customizeNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "AccentColor")
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
}

extension HotelListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hotel Cell", for: indexPath as IndexPath) as! HotelCollectionViewCell
        cell.backgroundColor = UIColor.secondarySystemGroupedBackground
        cell.layer.cornerRadius = 8
        let starString = "★★★★★"
        let title = "Best Western Plus Seraphine Hammersmith Hotel \(starString)"
        let range = (title as NSString).range(of: starString)
        let mutableAttributedString = NSMutableAttributedString.init(string: title)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemYellow, range: range)
        cell.title.attributedText = mutableAttributedString
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
}

extension HotelListViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func setUpSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "Search hotels from this list"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}
