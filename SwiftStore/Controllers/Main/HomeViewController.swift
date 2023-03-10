//
//  HomeViewController.swift
//  SwiftStore
//
//  Created by Виталий Гринчик on 1.02.23.
//

import UIKit

// MARK: - CustomButtonDelegate
// Для понимания можно читать, как "делегат класса CustomButton"
protocol CustomButtonDelegate {
    
    func putIntoCart(_ product: Product)
    
    func removeFromCart(_ product: Product)
    
    func updateCartBage()
}

final class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - IB Outlets
    @IBOutlet var sellsCollectionView: UICollectionView!
    @IBOutlet var bestCollectionView: UICollectionView!
    @IBOutlet var recommendCollectionView: UICollectionView!
    
    // Data source for collection views
    var sellsProducts: [Product]!
    var bestProducts: [Product]!
    var recommendedProducts: [Product]!
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        
        // Assign notification observer: if notification occurs (has been "posted") center calls designated function
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateView),
            name: Notification.Name("updateView"),
            object: nil
        )
    }
    
    // Set custom buttons appearance in accordance with a cart
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateVisibleCells()
    }
    
    // Testing
//    override func viewDidDisappear(_ animated: Bool) {
//        Cart.printOut(from: "HOME")
//    }
    
    // MARK: - Setup tabbar view
    private func setupTabBar() {
        tabBarItem.image = UIImage(systemName: "house.fill")
        tabBarItem.title = "Главная"
        
        tabBarController?.tabBar.items?[2].image = UIImage(systemName: "cart.fill")
        tabBarController?.tabBar.items?[2].title = "Корзина"
    }

    //MARK: - Navigation
    // Programmed segue to ProductInfoViewController
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "ProductInfo", bundle: nil)
        if let productInfoVC = storyBoard.instantiateViewController(identifier: "productInfoVC") as? ProductInfoViewController {
            
            switch collectionView {
            case sellsCollectionView: productInfoVC.product = sellsProducts[indexPath.row]
            case bestCollectionView: productInfoVC.product = bestProducts[indexPath.row]
            default: productInfoVC.product = recommendedProducts[indexPath.row]
            }
            
            present(productInfoVC, animated: true)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case sellsCollectionView: return sellsProducts.count
        case bestCollectionView: return bestProducts.count
        default: return recommendedProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case sellsCollectionView:
            let cell = sellsCollectionView.dequeueReusableCell(withReuseIdentifier: "sellsCell", for: indexPath) as! CollectionViewCell
            cell.buyButton.delegate = self // указываем, что делегатом для кнопки (экземпляр класса CustomButton) является ЭТОТ (self - "сам") вью контроллер
            let product = sellsProducts[indexPath.row]  // определяем экземпляр продукта для ячейки
            
            cell.product = product  // передаем экземпляр продукта в свойство ячейки
            let configuredCell = configureCell(cell, for: product) // заполняем ячейку отображаемыми данными
            return configuredCell   // выдаем готовую ячейку
            
        case bestCollectionView:
            let cell = bestCollectionView.dequeueReusableCell(withReuseIdentifier: "bestCell", for: indexPath) as! CollectionViewCell
            cell.buyButton.delegate = self
            let product = bestProducts[indexPath.row]
            cell.product = product
            let configuredCell = configureCell(cell, for: product)
            return configuredCell
            
        default:
            let cell = recommendCollectionView.dequeueReusableCell(withReuseIdentifier: "recomendedCell", for: indexPath) as! CollectionViewCell
            cell.buyButton.delegate = self
            let product = recommendedProducts[indexPath.row]
            cell.product = product
            let configuredCell = configureCell(cell, for: product)
            return configuredCell
        }
    }
    
    // Fill cell content
    private func configureCell(_ cell: CollectionViewCell, for product: Product) -> UICollectionViewCell {
        cell.productImage.image = UIImage(named: product.image)
        cell.modelLabel.text = product.image
        
        cell.buyButton.initState = Cart.contains(product) ? false : true
        
        if product.onSale {
            // Strike out price text for discounted products
            let priceText = "$\(product.price)"
            let priceTextstroken = NSMutableAttributedString(string: priceText)
            priceTextstroken.addAttribute(.strikethroughStyle, value: 1, range: NSRange(location: 0, length: priceText.count))
            
            cell.priceDiscountLabel.text = "$\(product.priceDiscount)"
            cell.priceLabel.attributedText = priceTextstroken
        } else {
            cell.priceDiscountLabel.text = "$\(product.price)"
            cell.priceLabel.isHidden = true
        }
        return cell
    }
}

// MARK: - CollectionViewCellDelegate
// Реализация метода протокола
// Для понимания можно читать, как "Класс HomeViewController - делегат класса CustomButton"
extension HomeViewController: CustomButtonDelegate {
    
    func putIntoCart(_ product: Product) {
        Cart.append(product)
    }
        
    func removeFromCart(_ product: Product) {
            Cart.remove(product)
    }
    
    func updateCartBage() {
        tabBarController?.tabBar.items?[2].badgeValue = Cart.isEmpty ? nil : String(Cart.count)
    }
}

extension HomeViewController {
    
    // Update self view after presented controller has been dismissed
    @objc private func updateView() {
        updateCartBage()
        updateVisibleCells()
    }
  
    // Update visible collection cells custom button in accordance with cart content
    private func updateVisibleCells() {
        updateCells(for: sellsCollectionView)
        updateCells(for: bestCollectionView)
        updateCells(for: recommendCollectionView)
    }
    
    private func updateCells(for collectionView: UICollectionView) {
        let cellsForUpdate = collectionView.visibleCells
        let cellsIndexesForUpdate = cellsForUpdate.map { collectionView.indexPath(for: $0)! }
        collectionView.reloadItems(at: cellsIndexesForUpdate)
    }
}
