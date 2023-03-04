
import UIKit

import WebKit


class WikiViewController : UIViewController {
    
    
   
    let webView = WKWebView()
    
    
    var url : URL?
        
  
    
  
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        view.addSubview(webView)
        
        webView.load(URLRequest(url: self.url!))
        
        
      
       
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    
    // MARK: - Helpers
    public func setAdditive (additive:String)
    {
        
        if (Int(additive) != nil)
        {
            var str =  additive
            str = str.replacingOccurrences(of: " ", with: "_")
           
            self.url = URL(string:"https://en.wikipedia.org/wiki/E\(str)" )
        }
        else {
            var str =  additive.lowercased()
            str = str.replacingOccurrences(of: " ", with: "_")
           
            self.url = URL(string:"https://en.wikipedia.org/wiki/\(str)" )
        }
      
        
    }
    
    
}
