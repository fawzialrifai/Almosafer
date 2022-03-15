//
//  HotelListViewController.swift
//  Almosafer
//
//  Created by Fawzi Rifa'i on 10/03/2022.
//

import UIKit

class HotelListViewController: UIViewController {
    
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var dividerWidth: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let searchController = UISearchController(searchResultsController: nil)
    let refreshControl = UIRefreshControl()
    var isConnected = false
    var hotelStore = HotelStore(hotels: [:], hotelArray: [], filteredHotelArray: [])
    var isHotelsFiltered: Bool {
        if let searchBarText = searchController.searchBar.text {
            return searchController.isActive && !searchBarText.isEmpty
        } else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Dubai, United Arab Emirates", comment: "The name of the city")
        navigationItem.backButtonTitle = NSLocalizedString("Search Results", comment: "Back button title")
        navigationItem.backButtonDisplayMode = .minimal // hides the back button title.
        customizeNavigationBarAppearance()
        setUpSearchBar()
        changeDividerWidth()
        addShadow(to: buttonsView)
        setUpRefreshControl()
        refreshHotelsData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // fixes a retain cycle that happens when popping HotelListViewController from the navigation stack while the search controller is presented.
        searchController.dismiss(animated: false)
    }
    
    func customizeNavigationBarAppearance() {
        // customize navigation bar colors.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "NavigationBarColor")
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.tintColor = .white
    }
    
    func changeDividerWidth() {
        // The default logical coordinate space is measured using points. For Retina displays, the scale factor may be 3.0 or 2.0, and 1 point can be represented by nine or four pixels. To draw a 1-pixel divider we divide 1 point by the screen scale factor.
        dividerWidth.constant = 1 / UIScreen.main.scale
    }
    
    func setUpRefreshControl() {
        refreshControl.tintColor = UIColor(named: "ButtonColor")
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshHotelsData), for: .valueChanged)
    }
    
    @objc func refreshHotelsData() {
        refreshControl.beginRefreshing()
        if let url = URL(string: "https://sgerges.s3-eu-west-1.amazonaws.com/iostesttaskhotels.json") {
            hotelStore.isRefreshingHotelsData = true
            URLSession.shared.dataTask(with: url) { data,_,_  in
                DispatchQueue.main.async {
                    if let data = data {
                        self.isConnected = true
                        self.hotelStore.parse(json: data)
                    } else {
                        self.isConnected = false
                        self.addEmptyDataSetViewWithText("Cannot load hotels because your iPhone is not connected to the Internet.")
                    }
                    self.refreshControl.endRefreshing()
                    self.hotelStore.isRefreshingHotelsData = false
                    self.hotelStore.sortHotels(by: self.hotelStore.sortedBy ?? .None)
                    self.reloadCollectionView()
                }
            }.resume()
        }
    }
    
    func addEmptyDataSetViewWithText(_ text: String) {
        let emptyDataSetView = UIView(frame: CGRect(x: collectionView.frame.minX, y: collectionView.frame.minY, width: collectionView.frame.width, height: collectionView.frame.height))
        let label = UILabel()
        label.text = NSLocalizedString(text, comment: "")
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundView = emptyDataSetView
        emptyDataSetView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: emptyDataSetView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: emptyDataSetView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: emptyDataSetView.widthAnchor, constant: -32).isActive = true
    }
    
    func removeEmptyDataSetView() {
        collectionView.backgroundView = nil
    }
    
    func reloadCollectionView() {
        if isConnected {
            if isHotelsFiltered {
                if hotelStore.filteredHotelArray?.count == 0 {
                    addEmptyDataSetViewWithText("No Results")
                } else {
                    removeEmptyDataSetView()
                }
            } else {
                if hotelStore.hotelArray?.count == 0 {
                    addEmptyDataSetViewWithText("No Hotels")
                } else {
                    removeEmptyDataSetView()
                }
            }
        }
        collectionView.reloadData()
    }
    
    @IBAction func presentSortOptions() {
        let alertController = UIAlertController(title: NSLocalizedString("Sort By:", comment: ""), message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Recommended", comment: ""), style: .default, handler: { action in
            self.hotelStore.sortHotels(by: .Recommended)
            self.reloadCollectionView()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Lowest Price", comment: ""), style: .default, handler: { action in
            self.hotelStore.sortHotels(by: .LowestPrice)
            self.reloadCollectionView()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Star Rating", comment: ""), style: .default, handler: { action in
            self.hotelStore.sortHotels(by: .StarRating)
            self.reloadCollectionView()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Distance", comment: ""), style: .default, handler: { action in
            self.hotelStore.sortHotels(by: .Distance)
            self.reloadCollectionView()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel))
        present(alertController, animated: true)
    }
    
    @IBAction func pushMapViewController() {
        if let mapViewController = storyboard?.instantiateViewController(withIdentifier: "Map") as? MapViewController {
            mapViewController.hotelArray = hotelStore.hotelArray
            navigationController?.pushViewController(mapViewController, animated: true)
        }
    }
    
}

extension HotelListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isHotelsFiltered ? hotelStore.filteredHotelArray!.count : hotelStore.hotelArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hotel Cell", for: indexPath as IndexPath) as! HotelCollectionViewCell
        cell.tag = indexPath.row
        let hotel = isHotelsFiltered ? hotelStore.filteredHotelArray![indexPath.row] : hotelStore.hotelArray![indexPath.row]
        cell.imageView.image = hotel.thumbnail
        if hotel.isThumbnailDownloaded != true {
            hotel.downloadThumbnail() { thumbnail in
                if cell.tag == indexPath.row {
                    cell.imageView.image = thumbnail
                }
            }
        }
        cell.title.attributedText = hotel.attributedName
        cell.reviewScore.text = "\(hotel.review?.score ?? 0.0)"
        cell.reviewScore.backgroundColor = UIColor(hex: hotel.review?.scoreColor ?? "")
        cell.reviewScoreDescription.text = hotel.review?.scoreDescription[languageCode]
        cell.reviewScoreDescription.textColor = UIColor(hex: hotel.review?.scoreColor ?? "")
        cell.reviewCount.text = String(format: NSLocalizedString("%d reviews", comment: ""), hotel.review?.count ?? 0)
        cell.address.text = hotel.localizedAddress
        cell.price.text = hotel.priceWithCurrencyCode
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
}

extension HotelListViewController: UISearchResultsUpdating {
    
    func setUpSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = NSLocalizedString("Search for a hotel", comment: "Search bar placeholder")
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchBarText = searchController.searchBar.text {
            hotelStore.filterHotelsForSearchBarText(searchBarText)
            reloadCollectionView()
        }
    }
    
}

func addShadow(to view: UIView) {
    view.layer.masksToBounds = false
    view.layer.shadowOffset = CGSize.zero
    view.layer.shadowRadius = 0.5
    view.layer.shadowOpacity = 0.5
}

extension UIColor {
    public convenience init(hex: String) {
        let scanner = Scanner(string: String(hex.dropFirst()))
        var hexNumber: UInt64 = 0
        if scanner.scanHexInt64(&hexNumber) {
            let red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            let green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            let blue = CGFloat(hexNumber & 0x0000ff) / 255
            self.init(red: red, green: green, blue: blue, alpha: 1)
            return
        }
        self.init(cgColor: UIColor.secondaryLabel.cgColor)
    }
}

var languageCode: String {
    get {
        if let languageCode = Locale.current.languageCode {
            return languageCode
        } else {
            return "en"
        }
    }
}
