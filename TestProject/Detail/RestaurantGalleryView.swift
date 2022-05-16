//
//  RestaurantGalleryView.swift

import UIKit
import SDWebImage

protocol RestaurantGalleryViewDelegate: class {
    func imageWasLoadedWithSize(size: CGSize)
}

class RestaurantGalleryView: UIView {
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private weak var delegate: RestaurantGalleryViewDelegate?
    private var urls: [String] = []
    private var downloadedImageSize: CGSize?
    
    func setupImagesUrls(urls:[String], delegate: RestaurantGalleryViewDelegate) {
        self.delegate = delegate
        self.urls = urls
        
        galleryCollectionView.reloadData()
        
        let cellWidth = self.galleryCollectionView.bounds.size.width
        
        DispatchQueue.main.async {
            
            self.galleryCollectionView.setContentOffset(CGPoint(x: cellWidth, y: 0.0), animated: false)
            
        }
        
        pageControl.numberOfPages = urls.count - 2
    }
    
    private func updateGalleryViewHeight(imageSize: CGSize) {
        delegate?.imageWasLoadedWithSize(size: imageSize)
    }
    
    func reloadData() {
        
//        galleryCollectionView.reloadData()
        galleryCollectionView.collectionViewLayout.invalidateLayout()
    }
    
//    func setupCollectionView() {
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets.zero
//        layout.minimumInteritemSpacing = 0.0//(17.0 / 343.0) * restaurantCollectionView.frame.width
//        let height = galleryCollectionView.bounds.height * 0.8
//        let width = galleryCollectionView.bounds.width * 0.8
//        layout.itemSize = CGSize(width: width, height: height)
//        layout.scrollDirection = .horizontal
//        galleryCollectionView.collectionViewLayout = layout
//    }
}

extension RestaurantGalleryView: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        pageControl.currentPage = page - 1
      
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        pageControl.currentPage = page - 1
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if let cell = parentCell {
//
//            cell.addViewedPing()
//        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let numberOfCells = urls.count
        let cellWidth = self.galleryCollectionView.bounds.size.width
        
        if numberOfCells == 1 || numberOfCells == 0 {
              return
        }

        let regularContentOffset = cellWidth * CGFloat(numberOfCells - 2)

        if (scrollView.contentOffset.x >= (cellWidth * CGFloat(numberOfCells - 1))) {
           // print("cont x - ", scrollView.contentOffset.x, "\nval - ", cellWidth * CGFloat(numberOfCells - 1))
            
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x - regularContentOffset, y: 0.0)
        } else if (scrollView.contentOffset.x < cellWidth) {
          //  print("cont x - ", scrollView.contentOffset.x, "\nval - ", cellWidth)
            
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x + regularContentOffset, y: 0.0)
        }
        

    }
}

extension RestaurantGalleryView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsAmount = urls.count
        return itemsAmount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "GalleryCellIdentifier"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! RestaurantGalleryCollectionViewCell
        cell.tag = indexPath.row
        let urlString = urls[indexPath.row]
        let url = URL(string: urlString)
        
        cell.imageView.sd_setImage(with: url) { [weak self] (image, error, type, aUrl) in
            if image != nil {
                if self != nil {
//                    if self?.downloadedImageSize == nil {
//                        self?.updateGalleryViewHeight(imageSize: image!.size)
//                        self?.downloadedImageSize = image!.size
                        
                        if cell.imageView != nil {
                            print("multiplier1")
                            if cell.imageViewProportionalConstraint != nil {
                                cell.imageView.removeConstraint(cell.imageViewProportionalConstraint!)
                                cell.imageViewProportionalConstraint = nil
                            }
                            
                                let multiplier: CGFloat = image!.size.height / image!.size.width
                                print("multiplier = \(multiplier)")
                                let newConstraint = NSLayoutConstraint(item: cell.imageView!, attribute: .height, relatedBy: .equal, toItem: cell.imageView, attribute: .width, multiplier: multiplier, constant: 0)
                                cell.imageView.addConstraint(newConstraint)
                                cell.imageViewProportionalConstraint = newConstraint
                            if cell.imageViewBottomConstraint != nil {
                                cell.imageViewBottomConstraint?.isActive = false
                                cell.imageViewBottomConstraint = nil
                            }
                        }
//                    }
                }
            }
        }
        return cell
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.galleryCollectionView.bounds.size.width
        print("width = \(width)")
        let height = self.galleryCollectionView.bounds.size.height
        print("height = \(height)")
        let itemSize = CGSize(width: width, height: height)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let visibleCell = collectionView.visibleCells.last
//        var index = 0
//        if visibleCell != nil {
//            index = collectionView.indexPath(for: visibleCell!)?.row ?? 0
//        }
//        pageControl.currentPage = index
    }
    
}
