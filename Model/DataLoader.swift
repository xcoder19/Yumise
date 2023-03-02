

import Foundation


public class DataLoader {
    
    @Published var foodAdditives = [Additive]()
    @Published var foodAdditivesDescription = [String]()
    
    init() {
      
        load()
    }
    func load()  {
        if let fileLocation = Bundle.main.url(forResource: "additives", withExtension: "json")  {
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([Additive].self, from: data)
                self.foodAdditives = dataFromJson
                dataFromJson.forEach { additive in
                    self.foodAdditivesDescription.append(additive.descriptionAdditive)
                    self.foodAdditivesDescription.append(additive.number)
                   
                    
                }
            }
            catch {
                print(error)
            }
        }
    }
    
 
    
    
}

public class DataEncoder {
    @Published var SavedFood = [Food]()
    init(food:[Food]?)
    {
        loadFood()
      if (food != nil)
        {
          encode(food: food!)
      }
       
        
    }
    
     func encode(food:[Food])
    {
        let encoder = JSONEncoder()
        
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = docsURL.appendingPathComponent("food").appendingPathExtension("json")
       
            do {
                loadFood()
                var foodarray : [Food] = SavedFood
               
                foodarray.append(food[0])
              
                
               let encodedFood = try encoder.encode(foodarray)
               
                
                try encodedFood.write(to: url , options: .noFileProtection)
                
            }
            catch {
                print(error)
            }
        
    }
    
    
     func loadFood()
    {
        
            let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = docsURL.appendingPathComponent("food").appendingPathExtension("json")
        
        
            let decoder = JSONDecoder()
        if let data = try? Data.init(contentsOf: url)
        {
            if let decodedFood = try? decoder.decode([Food].self, from: data)
            {
               
                self.SavedFood = decodedFood
                
            }
        }
        
    }
    
    func deleteFood(food:Food)
    {
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = docsURL.appendingPathComponent("food").appendingPathExtension("json")
        let encoder = JSONEncoder()
        do {
            loadFood()
            var foodarray : [Food] = SavedFood
           
            foodarray.removeAll { F in
                F.foodName == food.foodName
            }
          
            
           let encodedFood = try encoder.encode(foodarray)
           
            
            try encodedFood.write(to: url , options: .noFileProtection)
            
        }
        catch {
            print(error)
        }
        
        
    }
}


public class AddedFoodEncoder {
    @Published var AddedFood = [Food]()
    init(food:[Food]?)
    {
        loadFood()
      if (food != nil)
        {
          encode(food: food!)
      }
       
        
    }
    
     func encode(food:[Food])
    {
        let encoder = JSONEncoder()
        
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = docsURL.appendingPathComponent("Addedfood").appendingPathExtension("json")
       
            do {
                loadFood()
                var foodarray : [Food] = AddedFood
               
                foodarray.append(food[0])
              
                
               let encodedFood = try encoder.encode(foodarray)
               
                
                try encodedFood.write(to: url , options: .noFileProtection)
                
            }
            catch {
                print(error)
            }
        
    }
    
    
     func loadFood()
    {
        
            let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = docsURL.appendingPathComponent("Addedfood").appendingPathExtension("json")
        
        
            let decoder = JSONDecoder()
        if let data = try? Data.init(contentsOf: url)
        {
            if let decodedFood = try? decoder.decode([Food].self, from: data)
            {
               
                self.AddedFood = decodedFood
                
            }
        }
        
    }
    func deleteFood(food:Food)
    {
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = docsURL.appendingPathComponent("Addedfood").appendingPathExtension("json")
        let encoder = JSONEncoder()
        do {
            loadFood()
            var foodarray : [Food] = AddedFood
           
            foodarray.removeAll { F in
                F.foodName == food.foodName
            }
          
            
           let encodedFood = try encoder.encode(foodarray)
           
            
            try encodedFood.write(to: url , options: .noFileProtection)
            
        }
        catch {
            print(error)
        }
        
        
    }
    
    
    
}
