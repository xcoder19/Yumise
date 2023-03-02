//
//  ResultsViewController.swift
//  toxicFoodDetector
//
//  Created by hedi on 26/2/2023.
//

import UIKit


class ResultsViewController : UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    
    // MARK: - Properties
    let tableView = UITableView()
    
    
    var array = [String]()
    {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var clearArray : Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        
        tableView.register(ResultsCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
                                                                 
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(handleSave))
                                                                 
      
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    //MARK: - Selectors
    
    @objc func handleDone()
    {
        
        self.array = [String]()
        
        self.dismiss(animated: true)
    }
    
    @objc func handleSave()
    {
        
        
        let alert = UIAlertController(title: "add your Product", message: "", preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "food name"
            field.returnKeyType = .next
            field.keyboardType = .default
        }
        
        alert.addTextField { field in
            
           
            
            
            field.placeholder = "description"
            field.returnKeyType = .default
            field.keyboardType = .default
            
           
        }
        
        
     
        
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "save", style: .default,handler: { _ in
            guard let fields = alert.textFields, fields.count == 2 else {
                return
            }
            let foodNameField = fields[0]
            let descriptionField = fields[1]
            
            guard let foodName = foodNameField.text, !foodName.isEmpty,
                  let description = descriptionField.text, !description.isEmpty
                   
             else {
                 return
            }
            
            let food = Food(foodName: foodName, Description: description)
            
            let foodarr : [Food] = [food]
            
            DataEncoder(food: foodarr).encode(food: foodarr)
            
            
        }))
        present(alert,animated: true)
    }
    
    

    
        
    // MARK: - helpers
    func configureUI()
    
    {
       
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath)
        
        if (Int(array[indexPath.row]) != nil)
        {
            cell.textLabel?.text = "E\(array[indexPath.row])"
        }
        else {
            cell.textLabel?.text = array[indexPath.row]
        }
        
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let vc = WikiViewController()
        vc.setAdditive(additive: self.array[indexPath.row])
        
        present(vc,animated: true)
        
//        let nc = UINavigationController(rootViewController: vc)
//        nc.modalPresentationStyle = .overCurrentContext
//        self.navigationController?.present(nc, animated: true)
        
       
       
    }
    
    
}


