

import UIKit


class SavedController: UICollectionViewController, UITableViewDelegate,UITableViewDataSource {
    
    
   
    
    // MARK: - Properties
    
    let tableView = UITableView()
    
    var SavedFood : [Food] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SavedFood.append(contentsOf: DataEncoder(food: nil).SavedFood)
        
        collectionView.backgroundColor = .white
        
        view.addSubview(tableView)
        
        
        tableView.register(ResultsCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
       // self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
        self.navigationController?.title = "Saved Products"
        self.navigationItem.title = "Saved Products"
        
      
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        SavedFood = DataEncoder(food: nil).SavedFood
        removeDuplicateElements(arr:SavedFood)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: Actions
    
    @objc func handleEdit()
    {
        
    }
    
    // MARK: - Helpers
    
    func removeDuplicateElements(arr:[Food])
    {
        var uniqueElements: [Food] = []
        for x in SavedFood {
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
       
        SavedFood = uniqueElements
    }
    
    
    
}

extension SavedController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SavedFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath)
        cell.textLabel?.text = SavedFood[indexPath.row].foodName
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        let pop = SavedFoodController(title: SavedFood[indexPath.row].foodName, description: SavedFood[indexPath.row].Description)
        
          present(pop,animated:true)
        
        
        
       
       
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            DataEncoder(food: nil).deleteFood(food: SavedFood[indexPath.row])
            SavedFood = DataEncoder(food: nil).SavedFood
            removeDuplicateElements(arr:SavedFood)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    

}
