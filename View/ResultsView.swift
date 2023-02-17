

import UIKit
private let reuseIdentifier = "reuseResultsCell"



class ResultsView : UIView {
    
    //MARK: - Properties
    static let shared = ResultsView()
    
    
     var tableView = UITableView()
     var expansionState: ExpansionState!
   
    
    var arr = [String]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    enum ExpansionState {
        case NotExpanded
        case PartiallyExpanded
        case FullyExpanded
        case ExpandedToSearch
    }
    
   
   
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureTableView()
        expansionState = .NotExpanded
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Actions
    
   
    
      func handleSwipeUp()  {
        
            if expansionState == .NotExpanded {
                DispatchQueue.main.async {
                    self.animateResultsView(targetPosition: self.frame.origin.y - 80) { (_) in
                        self.expansionState = .PartiallyExpanded
                    }
                }
                     
           }
                 
    
    }
    
    //MARK: - Helpers
    
     func animateResultsView(targetPosition: CGFloat, completion:@escaping(Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.frame.origin.y = targetPosition
        }, completion: completion)
    }
    func  configureTableView() {
        tableView.rowHeight = 72
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResultsCell.self, forCellReuseIdentifier: reuseIdentifier)
        addSubview(tableView)
        tableView.anchor(top:topAnchor,left:leftAnchor,bottom:bottomAnchor, right: rightAnchor,paddingTop:20, paddingBottom: 100)
        
    }
    
    
   
    
    
  
}

extension ResultsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ResultsCell
        cell.textLabel?.text =  arr[indexPath.row]
        return cell
    }
    
    
}


