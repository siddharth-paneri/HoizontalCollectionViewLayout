//
//  ViewController.swift
//  HorizontalCollectionViewLayout
//
//  Created by Siddharth Paneri on 24/04/18.
//  Copyright © 2018 Siddharth Paneri. All rights reserved.
//

import UIKit

let ROWS : UInt = 2
let COLUMNS : UInt = 2
class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var randomCount : Int = 8
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        
        let customLayout = HorizontalCollectionViewLayout()
        customLayout.rowsPerPage = ROWS
        customLayout.columnsPerPage = COLUMNS
        customLayout.cellWidth = 187
        customLayout.cellHeight = 100
        
        self.collectionView.collectionViewLayout = customLayout
        
        
        var totalPagesRequired = self.randomCount / Int(ROWS * COLUMNS)
        if self.randomCount % Int(ROWS * COLUMNS) > 0 {
            totalPagesRequired += 1
        }
        self.pageControl.numberOfPages = totalPagesRequired
        self.pageControl.currentPage = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func button_RandomCount_Clicked(_ sender: Any) {
        self.randomCount = Int(arc4random_uniform(7)) + 1
        
        var totalPagesRequired = self.randomCount / Int(ROWS * COLUMNS)
        if self.randomCount % Int(ROWS * COLUMNS) > 0 {
            totalPagesRequired += 1
        }
        self.pageControl.numberOfPages = totalPagesRequired
        self.pageControl.currentPage = 0
        self.collectionView.reloadData()
        self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}

extension ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


extension ViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.randomCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimpleCell", for: indexPath) as! SimpleCell
        cell.label.text = "\(indexPath.item)"
        cell.backgroundColor = UIColor.clear
        cell.label.layer.borderColor = UIColor.black.cgColor
        cell.label.layer.cornerRadius = 8.0
        cell.label.layer.borderWidth = 1.0
        return cell
    }
    
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 187.5, height: 100)
    }
}


extension ViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.collectionView == scrollView {
            let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            self.pageControl.currentPage = pageIndex
        }
        
    }
}



