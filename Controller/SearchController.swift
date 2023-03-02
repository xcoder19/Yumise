

import UIKit


class SearchController: UIViewController , UITableViewDelegate, UITableViewDataSource {
  
    
    
    //MARK: - properties
    let tableView = UITableView()
    private var foodAdditivesDescription = DataLoader().foodAdditivesDescription
      
    
    
    private var filteredFoodAdditives =  [String]()
    
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode : Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    var AddedFood : [Food] = []
       
    
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        view.addSubview(tableView)
        
        
        tableView.register(ResultsCell.self, forCellReuseIdentifier: "ola")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))
                                                                 
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(handleAdd))
        
        self.navigationController?.title = "Search"
       
        
        AddedFood.append(contentsOf: AddedFoodEncoder(food: nil).AddedFood)
        removeDuplicateFood(arr: AddedFood)
        removeDuplicateElements(arr: foodAdditivesDescription)
        for x in AddedFood {
            foodAdditivesDescription.append(x.foodName)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        AddedFood = AddedFoodEncoder(food: nil).AddedFood
        for x in AddedFood {
            foodAdditivesDescription.append(x.foodName)
        }
        removeDuplicateFood(arr: AddedFood)
        removeDuplicateElements(arr: foodAdditivesDescription)
       
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    // MARK: - Actions
    
    @objc func handleSearch()
    {
        
        configureSearchController()
        
        
    }
    
    @objc func handleAdd()
    {
        let alert = UIAlertController(title: "add a new Additive", message: "", preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "additive name"
            field.returnKeyType = .next
            field.keyboardType = .default
        }
        
        alert.addTextField { field in
            
           
            
            
            field.placeholder = "additive code"
            field.returnKeyType = .default
            field.keyboardType = .default
            
           
        }
        
        
     
        
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "save", style: .default,handler: { _ in
            guard let fields = alert.textFields, fields.count == 2 else {
                return
            }
            let additiveName = fields[0]
            let additiveCode = fields[1]
            
            guard let Name = additiveName.text, !Name.isEmpty,
                  let Code = additiveCode.text, !Code.isEmpty
                   
             else {
                 return
            }
            
            let food = Food(foodName: Name, Description: Code)
            
            let foodarr : [Food] = [food]
            
            AddedFoodEncoder(food: foodarr).encode(food: foodarr)
            
            self.AddedFood = AddedFoodEncoder(food: nil).AddedFood
            for x in self.AddedFood {
                self.foodAdditivesDescription.append(x.foodName)
            }
            self.removeDuplicateFood(arr: self.AddedFood)
            self.removeDuplicateElements(arr: self.foodAdditivesDescription)
            self.tableView.reloadData()
            
        }))
        present(alert,animated: true)
       
        
    }
    
    //MARK: - Helpers
    
    func configureSearchController()
    {
        
        if (navigationItem.searchController == searchController)
        {
            navigationItem.searchController = nil
        }
        else {
            navigationItem.searchController = searchController
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchBar.placeholder = "Search"
            
            definesPresentationContext = false
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        
        
    }
    
    func removeDuplicateElements(arr:[String])
    {
        var uniqueElements: [String] = []
        for x in arr {
            var exist:Bool = false
            
            for y in uniqueElements {
                
                if (x == y)
                 {
                     exist = true
                 }
                
            }
             
            if exist == false {
                uniqueElements.append(x)
            }
            
            
            
           }
       
       
         self.foodAdditivesDescription = uniqueElements
        
        
    }
    
    
    func removeDuplicateFood(arr:[Food])
    {
        var uniqueElements: [Food] = []
        for x in AddedFood {
            var exist:Bool = false
            
            for y in uniqueElements {
                
                if (x.foodName == y.foodName)
                 {
                     exist = true
                 }
                
            }
             
            if exist == false {
                uniqueElements.append(x)
            }
            
            
            
           }
       
        AddedFood = uniqueElements
    }
    
    
    
    
}

extension SearchController  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count is " , foodAdditivesDescription.count)
        return inSearchMode ? filteredFoodAdditives.count : foodAdditivesDescription.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ola",for:indexPath)
        let food = inSearchMode ? filteredFoodAdditives.sorted()[indexPath.row] : foodAdditivesDescription.sorted()[indexPath.row]
        if (Int(food) != nil)
        {
            cell.textLabel?.text = "E\(food)"
        }
        else {
            cell.textLabel?.text = food
        }
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = WikiViewController()
        if inSearchMode {
            vc.setAdditive(additive: self.filteredFoodAdditives.sorted()[indexPath.row])
        }
        else {
            vc.setAdditive(additive: self.foodAdditivesDescription.sorted()[indexPath.row])
        }
        
        
        present(vc,animated: true)
        
       
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
       
        if (indexPath.row > foodAdditivesDescription.count - AddedFood.count - 1)
        {
            return .delete
        }
        else {
            return .none
        }
        
            
       
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if  editingStyle == .delete {
           
            tableView.beginUpdates()
           
            let food = Food(foodName: foodAdditivesDescription.sorted()[indexPath.row], Description: "")
            let foodName = foodAdditivesDescription.sorted()[indexPath.row]
            AddedFoodEncoder(food: nil).deleteFood(food: food)
            
            AddedFood.append(contentsOf: AddedFoodEncoder(food: nil).AddedFood)
            
            removeDuplicateFood(arr: AddedFood)
            for x in AddedFood {
                foodAdditivesDescription.append(x.foodName)
            }
            removeDuplicateElements(arr: foodAdditivesDescription.sorted())
            
            foodAdditivesDescription.removeAll { f in
                f == foodName
            }
            tableView.reloadData()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredFoodAdditives = foodAdditivesDescription.filter({ additive in
            additive.lowercased().contains(searchText)
            //return additive.lowercased() == searchText
        })
        
        self.tableView.reloadData()
        
    }
    
    
}
