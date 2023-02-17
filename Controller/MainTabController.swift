

import UIKit


class MainTabController: UITabBarController {
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    
    //MARK: - Heplers
    
    func configureViewControllers() {
        view.backgroundColor = .clear
        
        let scanner = templateNavigationController(unselectedImage: UIImage(systemName: "viewfinder.circle")!, selectedImage: UIImage(systemName: "viewfinder.circle.fill")!, rootViewController: ScannerController())
        
        let saved = templateNavigationController(unselectedImage: UIImage(systemName: "bookmark.circle")!, selectedImage: UIImage(systemName: "bookmark.circle.fill")!, rootViewController: SavedController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let settings = templateNavigationController(unselectedImage: UIImage(systemName: "gearshape")!, selectedImage: UIImage(systemName: "gearshape.fill")!, rootViewController: SettingsController())
        
        viewControllers = [scanner, saved , settings]
        
        
        tabBar.tintColor = .black
    }
    
    func templateNavigationController(unselectedImage:UIImage , selectedImage : UIImage , rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        
        nav.navigationBar.tintColor = .black
        return nav
    }
    
}
