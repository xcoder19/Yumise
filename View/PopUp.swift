//
//  PopUp.swift
//  toxicFoodDetector
//
//  Created by hedi on 2/3/2023.
//

import UIKit

class PopUp:UIView
{
    
    fileprivate let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28,weight: .bold)
        label.text = "Pringels"
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let descriptioneLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16,weight: .bold)
        label.textAlignment = .center
        label.text = "Description"
        
        
        return label
    }()
    
    
    
    fileprivate let container : UIView = {
        let v = UIView()
        
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        return v
        
    } ()
    
    fileprivate lazy var stack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [titleLabel,descriptioneLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
        
        self.frame = UIScreen.main.bounds
        self.addSubview(container)
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45).isActive = true
        
        
        container.addSubview(stack)
       // stack.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        //stack.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        stack.spacing = 60
        
        
    }
    
    public func set(title : String , description : String)
    {
        self.titleLabel.text = title
        self.descriptioneLabel.text = description
    }
    
    //MARK: - Actions
    
    @objc func animateOut()
    {
//        UIView.animate(withDuration: 0.3)
//        {
//            self.container.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
//        }
        self.alpha = 0
       
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
