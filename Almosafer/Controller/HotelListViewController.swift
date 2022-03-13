//
//  HotelListViewController.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 10/03/2022.
//

import UIKit

class HotelListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dividerWidth: NSLayoutConstraint!
    @IBOutlet weak var buttonStackView: UIView!
    
    var hotels = [Hotel]()
    var filteredHotels = [Hotel]()
    var isNetworkActivityIndicatorVisible = false
    let searchController = UISearchController(searchResultsController: nil)
    var isHotelsFiltered: Bool { searchController.isActive && !searchController.searchBar.text!.isEmpty }
    let refreshControl = UIRefreshControl()
    var sortedBy = SortBy.None
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBarAppearance()
        fixDividerWidth()
        setUpSearchBar()
        setUpShadow(for: buttonStackView)
        title = NSLocalizedString("Dubai, United Arab Emirates", comment: "The name of the city")
        navigationItem.backButtonTitle = NSLocalizedString("Search Results", comment: "")
        navigationItem.backButtonDisplayMode = .minimal
        setUpRefreshControl()
        refreshHotelData()
    }
    
    func setUpRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshHotelData), for: .valueChanged)
    }
    
    @objc func refreshHotelData() {
        refreshControl.beginRefreshing()
        if let url = URL(string: "https://sgerges.s3-eu-west-1.amazonaws.com/iostesttaskhotels.json") {
            isNetworkActivityIndicatorVisible = true
            collectionView.reloadData()
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        if let jsonHotels = try? JSONDecoder().decode(Hotels.self, from: data) {
                            self.hotels.removeAll()
                            for (_, value) in jsonHotels.hotels {
                                self.hotels.append(value)
                            }
                        }
                        self.refreshControl.endRefreshing()
                        self.isNetworkActivityIndicatorVisible = false
                        self.sortHotels(by: self.sortedBy)
                    }
                } else {
                    self.refreshControl.endRefreshing()
                    self.isNetworkActivityIndicatorVisible = false
                    self.collectionView.reloadData()
                }
            }.resume()
        }
    }
    
    func fixDividerWidth() {
        dividerWidth.constant = 1 / UIScreen.main.scale
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
        case .None:
            break
        case .Recommended:
            if isHotelsFiltered {
                filteredHotels.sort(by: { $0.priorityScore > $1.priorityScore })
            } else {
                hotels.sort(by: { $0.priorityScore > $1.priorityScore })
            }
        case .LowestPrice:
            if isHotelsFiltered {
                filteredHotels.sort(by: {
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
            } else {
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
            }
        case .StarRating:
            if isHotelsFiltered {
                filteredHotels.sort(by: { $0.starRating ?? 0 > $1.starRating ?? 0 })
            } else {
                hotels.sort(by: { $0.starRating ?? 0 > $1.starRating ?? 0 })
            }
        case .Distance:
            if isHotelsFiltered {
                filteredHotels.sort(by: { $0.distanceInMeters < $1.distanceInMeters })
            } else {
                hotels.sort(by: { $0.distanceInMeters < $1.distanceInMeters })
            }
        }
        sortedBy = sortOption
        collectionView.reloadData()
    }
    
}

extension HotelListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let emptyView = UIView(frame: CGRect(x: collectionView.frame.minX, y: collectionView.frame.minY, width: collectionView.frame.width, height: collectionView.frame.height))
        let label = UILabel()
        label.text = "No Hotels"
        label.textColor = .systemGray
        label.font = label.font.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        if isHotelsFiltered {
            if filteredHotels.count == 0 {
                collectionView.backgroundView = emptyView
                if isNetworkActivityIndicatorVisible {
                    label.removeFromSuperview()
                } else {
                    emptyView.addSubview(label)
                    label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
                    label.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
                }
            } else {
                label.removeFromSuperview()
                collectionView.backgroundView = nil
            }
            return filteredHotels.count
        } else {
            if hotels.count == 0 {
                collectionView.backgroundView = emptyView
                if isNetworkActivityIndicatorVisible {
                    label.removeFromSuperview()
                } else {
                    emptyView.addSubview(label)
                    label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
                    label.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
                }
            } else {
                label.removeFromSuperview()
                collectionView.backgroundView = nil
            }
            return hotels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hotel Cell", for: indexPath as IndexPath) as! HotelCollectionViewCell
        cell.tag = indexPath.row
        let hotel = isHotelsFiltered ? filteredHotels[indexPath.row] : hotels[indexPath.row]
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
            cell.reviewScore.text = "\(hotelReview.score)"
            cell.reviewScore.backgroundColor = UIColor(hex: hotelReview.scoreColor)
            cell.reviewScoreDescription.text = hotelReview.scoreDescription[Locale.current.languageCode!]
            cell.reviewScoreDescription.textColor = UIColor(hex: hotelReview.scoreColor)
            cell.reviewCount.text = String(format: NSLocalizedString("%d reviews", comment: ""), hotelReview.count)
        } else {
            cell.reviewScore.text = "0.0"
            cell.reviewScore.backgroundColor = UIColor.secondaryLabel
            cell.reviewScoreDescription.text = ""
            cell.reviewCount.text = String(format: NSLocalizedString("%d reviews", comment: ""), 0)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
}

extension HotelListViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    func setUpSearchBar() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = NSLocalizedString("Search for a hotel", comment: "Search placeholder")
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredHotels = hotels.filter { $0.name[Locale.current.languageCode!]!.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        collectionView.reloadData()
    }
    
}

enum SortBy: Codable {
    case None, Recommended, LowestPrice, StarRating, Distance
}

func setUpShadow(for view: UIView) {
    view.layer.masksToBounds = false
    view.layer.shadowOffset = CGSize.zero
    view.layer.shadowRadius = 0.5
    view.layer.shadowOpacity = 0.5
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b: CGFloat
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        return nil
    }
}
