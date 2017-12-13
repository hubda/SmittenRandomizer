//
//  RandomizerViewController.swift
//  SmittenRandomizer
//
//  Created by Daniel Huber on 12/11/17.
//  Copyright © 2017 Daniel Huber. All rights reserved.
//

import UIKit
import WebKit

class RandomizerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK: Properties
    @IBOutlet weak var CategoryPicker: UIPickerView!
    @IBOutlet weak var SubcategoryPicker: UIPickerView!
    @IBOutlet weak var MealNameLabel: UILabel!
    @IBOutlet weak var MealPictureButton: UIButton!
    var categories = [String]()
    var savoryCategory = [String]()
    var sweetCategory = [String]()
    var fruitCategory = [String]()
    var veggieCategory = [String]()
    var categoryPicked = ""
    var subcategoryPicked = ""
    var url = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        CategoryPicker.delegate = self
        CategoryPicker.dataSource = self
        SubcategoryPicker.delegate = self
        SubcategoryPicker.dataSource = self
        
        assignCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Pickers
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == CategoryPicker {
            //print("categories.count: \(categories.count)")
            return categories.count
        }
        else if pickerView == SubcategoryPicker {
            //print("sweetCategory.count: \(sweetCategory.count)")
            return sweetCategory.count
        }
        else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == CategoryPicker {
            //print("categories[row]: \(categories[row])")
            return categories[row]
        }
        else if pickerView == SubcategoryPicker {
            //print("sweetcategory[row]: \(sweetCategory[row])")
            return sweetCategory[row]
        }
        else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == CategoryPicker {
            categoryPicked = categories[row]
            print("Category: \(categories[row])")
        }
        else if pickerView == SubcategoryPicker {
            subcategoryPicked = sweetCategory[row]
            print("Subcategory: \(sweetCategory[row])")
        }
    }
    
    //MARK: Actions
    //Choose a random meal
    @IBAction func findRandomRecipe(_ sender: UIButton) {
        print("Randomize clicked")
        
    }
    
    //Go to the meal's recipe page
    @IBAction func goToRecipe(_ sender: UIButton) {
        print("Going to the meal's page")
    }
    
    
    //MARK: Private Functions
    func assignCategories() {
        categories = ["Any", "Savory", "Fruit", "Sweets", "Veggies"]
        //savoryCategory = ["Appetizers + Party Snacks", "Austrian", "Beans", "Beef", "Bourbon", "Brazilian", "Bread", "Breakfast", "British", "Brown Butter", "Brunch", "Budget"]
        sweetCategory = ["Any", "Bars", "Brownies/Blondies", "Cake", "Candy", "Celebration Cakes", "Chocolate", "Cookie", "Crumbles/Crisps", "Doughnut", "Everyday Cakes", "Ice Cream/Sorbet", "Popsicles", "Pudding", "Tarts/Pies", "Wedding Cake"]
    }

    func getMeals() {
        //Get meals from website.
        let regex = "^https"
        let url = NSURL(string: "https://smittenkitchen.com/recipes/")
        let request = URLRequest(url: url! as URL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            let urlContentString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            self.getUrl(str: urlContentString)
            print(urlContentString)
        })
        task.resume()
    }
    
    func getUrl(str: String) {
        let urlFormat = "https://smittenkitchen.com/recipes"
        let urlEnd =  "/?format=list"
        let newUrl = urlFormat + "/sweets/bars" + urlEnd
        if str.range(of: newUrl) != nil {
            print("Bars found")
        }
        else {
            print("Bars not found")
        }
    }
}

