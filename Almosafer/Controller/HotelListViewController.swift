//
//  HotelListViewController.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 10/03/2022.
//

import UIKit

enum SortBy {
    case Recommended, LowestPrice, StarRating, Distance
}

class HotelListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var hotels = [Hotel]()
    var isNetworkActivityIndicatorVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBarAppearance()
        setUpSearchBar()
        title = NSLocalizedString("Dubai, United Arab Emirates", comment: "The name of the city")
        if let url = URL(string: "https://sgerges.s3-eu-west-1.amazonaws.com/iostesttaskhotels.json") {
            isNetworkActivityIndicatorVisible = true
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        if let jsonHotels = try? JSONDecoder().decode(Hotels.self, from: data) {
                            for (_, value) in jsonHotels.hotels {
                                self.hotels.append(value)
                            }
                        }
                        self.isNetworkActivityIndicatorVisible = false
                        self.collectionView.reloadData()
                    }
                } else {
                    self.isNetworkActivityIndicatorVisible = false
                    self.collectionView.reloadData()
                }
            }.resume()
        }
    }
    
    func downloadImage(for hotel: Hotel, completionHandler: @escaping ((UIImage?) -> Void)) {
        if let url = URL(string: hotel.thumbnailUrl) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        hotel.imageData = data
                        hotel.downloaded = true
                        completionHandler(UIImage(data: data))
                    }
                }
            }.resume()
        }
    }
    
    func customizeNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "AccentColor")
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.tintColor = .white
    }
    
    @IBAction func showMap() {
        guard let mapViewController = storyboard?.instantiateViewController(withIdentifier: "Map") as? MapViewController else { return }
        mapViewController.hotels = hotels
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    @IBAction func showSortOptions() {
        let alertController = UIAlertController(title: NSLocalizedString("Sort By:", comment: ""), message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Recommended", comment: ""), style: .default, handler: { action in
            self.sortHotels(by: .Recommended)
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Lowest Price", comment: ""), style: .default, handler: { action in
            self.sortHotels(by: .LowestPrice)
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Star Rating", comment: ""), style: .default, handler: { action in
            self.sortHotels(by: .StarRating)
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Distance", comment: ""), style: .default, handler: { action in
            self.sortHotels(by: .Distance)
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel))
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }
    
    func sortHotels(by sortOption: SortBy) {
        switch sortOption {
        case .Recommended:
            hotels.sort(by: { $0.priorityScore > $1.priorityScore })
        case .LowestPrice:
            hotels.sort(by: {
                if let firstElementPrice = $0.price {
                    if let secondElementPrice = $1.price {
                        return firstElementPrice < secondElementPrice
                    } else {
                        return true
                    }
                } else {
                    return false
                }
            })
        case .StarRating:
            hotels.sort(by: { $0.starRating ?? 0 > $1.starRating ?? 0 })
        case .Distance:
            hotels.sort(by: { $0.distanceInMeters < $1.distanceInMeters })
        }
        collectionView.reloadData()
    }
    
}

extension HotelListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let emptyView = UIView(frame: CGRect(x: collectionView.frame.minX, y: collectionView.frame.minY, width: collectionView.frame.width, height: collectionView.frame.height))
        let activityIndicator = UIActivityIndicatorView(style: .large)
        let label = UILabel()
        label.text = "No Hotels"
        label.textColor = .systemGray
        label.font = label.font.withSize(30)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        if hotels.count == 0 {
            collectionView.backgroundView = emptyView
            if isNetworkActivityIndicatorVisible {
                label.removeFromSuperview()
                emptyView.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                activityIndicator.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
                activityIndicator.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
            } else {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                emptyView.addSubview(label)
                label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
                label.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
            }
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            label.removeFromSuperview()
            collectionView.backgroundView = nil
        }
        return hotels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hotel Cell", for: indexPath as IndexPath) as! HotelCollectionViewCell
        cell.tag = indexPath.row
        cell.backgroundColor = UIColor.secondarySystemGroupedBackground
        cell.layer.cornerRadius = 8
        let hotel = hotels[indexPath.row]
        cell.title.attributedText = hotel.attributedName
        if hotel.downloaded == true {
            cell.imageView.image = UIImage(data: hotel.imageData!)
        } else {
            cell.imageView.image = nil
            downloadImage(for: hotel) { image in
                if cell.tag == indexPath.row {
                    cell.imageView.image = image
                }
            }
        }
        cell.price.text = hotel.priceWithCurrency
        cell.address.text = hotel.address[Locale.current.languageCode!] as? String
        if let hotelReview = hotel.review {
            if hotelReview.count == 0 {
                cell.reviewStack.isHidden = true
            } else {
                cell.reviewStack.isHidden = false
                cell.reviewScore.text = "\(hotelReview.score)"
                cell.reviewScoreDescription.text = hotelReview.scoreDescription[Locale.current.languageCode!]
                cell.reviewCount.text = String(format: NSLocalizedString("%d reviews", comment: ""), hotelReview.count)
            }
            
        } else {
            cell.reviewStack.isHidden = true
        }
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
        searchController.searchBar.placeholder = NSLocalizedString("Search for a hotel", comment: "Search placeholder")
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}
