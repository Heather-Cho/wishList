//
//  ViewController.swift
//  0415
//
//  Created by t2023-m0114 on 4/15/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    private var currentProduct: RemoteProduct? = nil {
        didSet {
            guard let currentProduct = self.currentProduct else { return }
            
            DispatchQueue.main.async {
                self.categoryLabel.text = "\(currentProduct.category)  /  \(currentProduct.brand)"
                self.imageView.image = nil
                self.titleLabel.text = currentProduct.title
                self.descriptionLabel.text = currentProduct.description
                self.priceLabel.text = "price : \(currentProduct.price)$"
            }
            
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: currentProduct.thumbnail), let image = UIImage(data: data) {
                    DispatchQueue.main.async { self?.imageView.image = image }
                }
            }
        }
    }
    
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    

    
    //하단 버튼 3개
    //위시리스트에 저장
    @IBAction func saveButton(_ sender: UIButton) {
        self.saveWishProduct()
    }
    
    //다른상품으로 넘어가기
    @IBAction func skipButton(_ sender: UIButton) {
        self.fetchRemoteProduct()
    }
    //위시리스트 보기 버튼 클릭
    @IBAction func checkWishButton(_ sender: UIButton) {
            // WishListViewController를 가져옵니다.
            guard let nextVC = self.storyboard?
                .instantiateViewController(
                    identifier: "WishListViewController"
                ) as? WishListViewController else { return }
            
            // WishListViewController를 present 합니다.
            self.present(nextVC, animated: true)
    }
    
    
    
    
    // URLSession을 통해 RemoteProduct를 가져와 currentProduct 변수에 저장합니다.
    private func fetchRemoteProduct() {
        // 1 ~ 100 숫자 랜덤추출
        let productID = Int.random(in: 1 ... 100)
        
        // URLSession을 통해 RemoteProduct를 가져옵니다.
        if let url = URL(string: "https://dummyjson.com/products/\(productID)") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        // product를 디코드하여, currentProduct 변수에 담습니다.
                        let product = try JSONDecoder().decode(RemoteProduct.self, from: data)
                        self.currentProduct = product
                    } catch {
                        print("Decode Error: \(error)")
                    }
                }
            }
            
            // 네트워크 요청 시작
            task.resume()
        }
    }
    
    // currentProduct를 가져와 Core Data에 저장합니다.
    private func saveWishProduct() {
        
        guard let context = self.persistentContainer?.viewContext else { return }

        guard let currentProduct = self.currentProduct else { return }

        let wishProduct = Product(context: context)
        
        wishProduct.id = Int64(currentProduct.id)
        wishProduct.title = currentProduct.title
        wishProduct.price = currentProduct.price

        try? context.save()
    }
    
    
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //당겨서 새로 고침
    func initRefresh() {
        let refresh: UIRefreshControl = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshing(refresh:)), for: .valueChanged)
        self.scrollView.refreshControl = refresh
    }

    @objc func refreshing(refresh: UIRefreshControl) {
        self.fetchRemoteProduct() // 다른상품보기
        refresh.endRefreshing() // 새로고침 끝내기
    }
    

    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchRemoteProduct()
        initRefresh()
        
    }
    
    
    


}

