

import UIKit


class MainTabController: UITabBarController {
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    //MARK: - Heplers
    
    func configureViewControllers() {
        view.backgroundColor = .red
        
        let scanner = templateNavigationController(unselectedImage: UIImage(systemName: "viewfinder.circle")!, selectedImage: UIImage(systemName: "viewfinder.circle.fill")!, rootViewController: ScannerController())
        
        let saved = templateNavigationController(unselectedImage: UIImage(systemName: "bookmark.circle")!, selectedImage: UIImage(systemName: "bookmark.circle.fill")!, rootViewController: SavedController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let search = templateNavigationController(unselectedImage: UIImage(systemName: "magnifyingglass.circle")!, selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")!, rootViewController: SearchController())
        
        viewControllers = [scanner, saved , search]
        
        scanner.navigationController?.title = "Scanner"
        saved.navigationController?.title = "Saved Products"
        search.navigationController?.title = "Search"
        

        
        if #available(iOS 15, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            // correct the transparency bug for Navigation bars
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
                
            
      


        view.tintColor = .black;
        
       
    }
    
   
    
    func templateNavigationController(unselectedImage:UIImage , selectedImage : UIImage , rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
       
        nav.navigationBar.tintColor = .red
        
        
       
        return nav
    }
    
}
