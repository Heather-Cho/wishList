//
//  WishListViewController.swift
//  0415
//
//  Created by t2023-m0114 on 4/15/24.
//

import UIKit
import CoreData

class WishListViewController: UITableViewController {
    
    var VC = ViewController()
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    private var productList: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        setProductList()
   }

    // CoreData에서 상품 정보를 불러와, productList 변수에 저장합니다.
    private func setProductList() {
        guard let context = self.persistentContainer?.viewContext else { return }
    
        let request = Product.fetchRequest()
    
        if let productList = try? context.fetch(request) {
            self.productList = productList
        }
    }
    
    // productList의 count를 반환합니다.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productList.count
    }
    
    // 각 index별 tableView cell을 반환합니다.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let product = self.productList[indexPath.row]
        
        let id = product.id
        let title = product.title ?? ""
        let price = product.price
        
        cell.textLabel?.text = "[\(id)] \(title) - \(price)$"
        return cell
    }
    
    
    
    
    //삭제01. 목록을 스와이프하여 삭제 버튼을 노출하고 터치하면 삭제
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let selectedList = productList[indexPath.row]//코어데이터에서 삭제
        
        if editingStyle == .delete {
            persistentContainer?.viewContext.delete(selectedList) //코어데이터에서 삭제
            productList.remove(at: indexPath.row) // 프로덕트리스트에서 지워라
            tableView.deleteRows(at: [indexPath], with: .fade)
            
           let appdelegate = (UIApplication.shared.delegate as! AppDelegate)//코어데이터에서 삭제
           appdelegate.saveContext()//코어데이터에서 삭제
            
            
        } else if editingStyle == .insert {
            
        }
        
        
    }
    

    
    //위시리스트 비우기 버튼
    @IBAction func resetButton(_ sender: Any) {
        
        guard let context = self.persistentContainer?.viewContext else { return }
        
        let request = Product.fetchRequest()
        
        if let productList = try? context.fetch(request) {
            self.productList = productList
        }
        
        context.delete(productList[0])
        
        productList.removeAll()
        tableView.reloadData()
        
        let appdelegate = (UIApplication.shared.delegate as! AppDelegate)
        appdelegate.saveContext()
    }
    
    
    
    
    
    
//    //플로팅 버튼으로 전체삭제
//    private func rotateFloatingButton() {
//        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
//    }
//    
//    let floatingButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Floating", for: .normal)
//
//        return button
//    }()
    
}
