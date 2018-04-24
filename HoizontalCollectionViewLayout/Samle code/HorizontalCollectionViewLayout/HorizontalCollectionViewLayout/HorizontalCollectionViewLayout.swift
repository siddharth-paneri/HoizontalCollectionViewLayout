/*
MIT License

Copyright (c) 2018 siddharth-paneri

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/


import UIKit

class HorizontalCollectionViewLayout : UICollectionViewLayout {
    
    
    var rowsPerPage : UInt = 1 {
        willSet {
            if newValue == 0 {
                self.rowsPerPage = 0
            } else {
                self.rowsPerPage = newValue
            }
        }
    }
    
    var columnsPerPage : UInt = 1 {
        willSet {
            if newValue == 0 {
                self.columnsPerPage = 0
            } else {
                self.columnsPerPage = newValue
            }
        }
    }
    
    var pages : Int {
        get {
            return _totalPagesRequired
        }
    }
    
    var cellWidth   : CGFloat = 100.0
    var cellHeight  : CGFloat = 100.0
    
    fileprivate var _totalPagesRequired : Int = 0
    fileprivate var _layoutAttributeCache: [UICollectionViewLayoutAttributes] = []
    
    override var collectionViewContentSize: CGSize {
        get {
            let widthPerPage = self.collectionView!.frame.size.width * CGFloat(_totalPagesRequired)
            let heightPerPage = self.collectionView!.frame.size.height
            
            return CGSize(width: widthPerPage, height: heightPerPage)
            
            //            return CGSize(width: CGFloat(_totalPagesRequired)*self.cellWidth*CGFloat(self.columnsPerPage), height: self.cellHeight*CGFloat(self.rowsPerPage))
        }
    }
    
    override func prepare() {
        if let collection = collectionView {
            /* get all items in collection view irrespective of the section */
            var allItemsInCollection : Int = 0
            for section in 0..<collection.numberOfSections {
                let totalItems = collection.numberOfItems(inSection: section)
                allItemsInCollection += totalItems
            }
            /* calculate total pages required from the number of items in collection */
            _totalPagesRequired = allItemsInCollection / Int(self.rowsPerPage * self.columnsPerPage)
            if allItemsInCollection % Int(self.rowsPerPage * self.columnsPerPage) > 0 {
                _totalPagesRequired += 1
            }
            
            if self._totalPagesRequired == 1 && allItemsInCollection <= self.columnsPerPage {
                /* loop through all the items of collection irrespective of section, to calculate its attribute. */
                for section in 0..<collection.numberOfSections {
                    let totalItems = collection.numberOfItems(inSection: section)
                    var currentRow : Int = 0
                    var currentColumn : Int = 0
                    var currentPage : Int = 0
                    //                    let pageWidth : CGFloat = self.collectionViewContentSize.width / CGFloat(_totalPagesRequired)
                    //                    let pageHeight : CGFloat = self.collectionViewContentSize.height
                    
                    let pageWidth : CGFloat = self.collectionView!.frame.size.width
                    let pageHeight : CGFloat = self.collectionView!.frame.size.height
                    
                    for itemIdx in 0..<totalItems {
                        if itemIdx >= (currentPage+1) * Int(self.rowsPerPage * self.columnsPerPage) {
                            /* next page calculation */
                            currentPage += 1
                            currentRow = 0
                            currentColumn = 0
                        }
                        
                        /* calculate the x position */
                        
                        
                        
                        let xPos : CGFloat = (CGFloat(currentColumn) * self.cellWidth) + ((pageWidth-(self.cellWidth*CGFloat(totalItems)))/2)
                        /* calculate the y position */
                        let yPos : CGFloat = (pageHeight - self.cellHeight)/2
                        /* calculate the frame */
                        let frame = CGRect(x: xPos, y: yPos, width: self.cellWidth, height: self.cellHeight)
                        /* get indexpath of the item */
                        let indexPath = IndexPath(row: itemIdx, section: section)
                        /* get layoutAttributes of the item from its indexPath*/
                        let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        /* set new frame to layoutAttributes */
                        layoutAttribute.frame = frame
                        /* append all attributes in chache */
                        _layoutAttributeCache.append(layoutAttribute)
                        
                        /* increment column to add nex item in next column */
                        currentColumn += 1
                        
                        /* check and update columns and rows as per current column/row */
                        if currentColumn >= self.columnsPerPage {
                            currentColumn = 0
                            currentRow += 1
                        }
                        if currentRow >= self.rowsPerPage {
                            currentRow = 0
                            currentColumn = 0
                        }
                    }
                }
            } else {
                /* loop through all the items of collection irrespective of section, to calculate its attribute. */
                for section in 0..<collection.numberOfSections {
                    let totalItems = collection.numberOfItems(inSection: section)
                    var currentRow : Int = 0
                    var currentColumn : Int = 0
                    var currentPage : Int = 0
                    //                    let pageWidth : CGFloat = self.collectionViewContentSize.width / CGFloat(_totalPagesRequired)
                    //                    let pageHeight : CGFloat = self.collectionViewContentSize.height
                    let pageWidth : CGFloat = self.collectionView!.frame.size.width
                    let pageHeight : CGFloat = self.collectionView!.frame.size.height
                    for itemIdx in 0..<totalItems {
                        if itemIdx >= (currentPage+1) * Int(self.rowsPerPage * self.columnsPerPage) {
                            /* next page calculation */
                            currentPage += 1
                            currentRow = 0
                            currentColumn = 0
                        }
                        
                        /* calculate the x position */
                        let xPos : CGFloat = (CGFloat(currentColumn) * self.cellWidth) + (CGFloat(currentPage)*pageWidth) + ((pageWidth-(self.cellWidth*CGFloat(self.columnsPerPage)))/2)
                        /* calculate the y position */
                        let yPos : CGFloat = (CGFloat(currentRow) * self.cellHeight)
                        /* calculate the frame */
                        let frame = CGRect(x: xPos, y: yPos, width: self.cellWidth, height: self.cellHeight)
                        /* get indexpath of the item */
                        let indexPath = IndexPath(row: itemIdx, section: section)
                        /* get layoutAttributes of the item from its indexPath*/
                        let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        /* set new frame to layoutAttributes */
                        layoutAttribute.frame = frame
                        /* append all attributes in chache */
                        _layoutAttributeCache.append(layoutAttribute)
                        
                        /* increment column to add nex item in next column */
                        currentColumn += 1
                        
                        /* check and update columns and rows as per current column/row */
                        if currentColumn >= self.columnsPerPage {
                            currentColumn = 0
                            currentRow += 1
                        }
                        if currentRow >= self.rowsPerPage {
                            currentRow = 0
                            currentColumn = 0
                        }
                    }
                }
            }
            
            
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        /* get attributes from cache */
        return _layoutAttributeCache.filter { $0.frame.intersects(rect)}
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        /* get attributes from cache */
        return _layoutAttributeCache.first { $0.indexPath == indexPath}
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        /* invalidate cache on bounds change */
        return true
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        /* reset cache on invalidation */
        _layoutAttributeCache = []
        _totalPagesRequired = 0
    }
    
}
