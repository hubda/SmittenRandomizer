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
    @IBOutlet weak var MealNameButton: UIButton!

    var categories = [String]()
    var savoryCategory = [String]()
    var sweetCategory = [String]()
    var fruitCategory = [String]()
    var veggieCategory = [String]()
    var categoryPicked = ""
    var subcategoryPicked = ""
    var url = ""
    var pageContents = ""
    var categoryPage = ""
    var categoryUrl = "https://smittenkitchen.com/recipes/"

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
        //Get the contents of the category page - done
        pageContents = getPageContents(url: categoryUrl)
        //Get the url of the recipe list from the picker - done
        categoryPage = getUrl(str: subcategoryPicked)
        //Get the recipe from the url
        let recipe = getRecipe(url: categoryPage)
        MealNameButton.titleLabel?.text = recipe
    }
    
    //Go to the meal's recipe page
    @IBAction func goToRecipe(_ sender: UIButton) {
        print("Going to the meal's page")
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    //MARK: Private Functions
    func assignCategories() {
        categories = ["Savory", "Fruit", "Sweets", "Veggies"]
        //savoryCategory = ["Appetizers + Party Snacks", "Austrian", "Beans", "Beef", "Bourbon", "Brazilian", "Bread", "Breakfast", "British", "Brown Butter", "Brunch", "Budget"]
        sweetCategory = ["Any", "Bars", "Brownies/Blondies", "Cake", "Candy", "Celebration Cakes", "Chocolate", "Cookie", "Crumbles/Crisps", "Doughnut", "Everyday Cakes", "Ice Cream/Sorbet", "Popsicles", "Pudding", "Tarts/Pies", "Wedding Cake"]
    }

    //Get the recipe from a url
    func getRecipe(url: String) -> String {
        //Get a recipe list from the recipes
        let pageContents = getPageContents(url: url)
        //print("pageContents: \(pageContents)")
        var regex: NSRegularExpression
        do {
            let pageArray = Array(pageContents.characters)
            //print("pageArray: \(pageArray)")
            //let dist = pageArray.endIndex - pageArray.startIndex
            let r = NSMakeRange(0, pageContents.utf16.count)
            print("range: \(r)")
            let pattern = "smittenkitchen.com/[0-9]{4}/[0-9]{2}/.+/"
            regex = try NSRegularExpression(pattern: pattern)
            print("regex: \(regex)")
            let firstMatch = regex.rangeOfFirstMatch(in: pageContents, range: r)
            var matchSize = firstMatch.length
            print("firstMatch: \(firstMatch.location)")
            var recipe: [String] = []
            var chars: [Character] = []
            let matches = regex.matches(in: pageContents, range: r)
            for match in matches {
                matchSize = match.length
                loop: for i in match.location..<match.location + matchSize {
                    if pageArray[i] == "\"" {
                        break loop
                    }
                chars.append(pageArray[i])
                }
                recipe.append(String(chars))
                print("pageArrayAtLocation: \(recipe)")
            }
            
            //print("matches: \(String(describing: matches))")
            
            /*for match in 0..<matches.count {
                match
            }*/
            
        } catch let error {
            print(error)
        }
        return ""
        
        
        /*var indecies = [Int]()
        var searchStartIndex = pageContents.startIndex
        while searchStartIndex < pageContents.endIndex, let range = pageContents.range(of: regex, range: searchStartIndex..<pageContents.endIndex), !range.isEmpty {
            let index = distance(from: pageContents.startIndex, to: range?.lowerBound)
            indecies.append(index)
            searchStartIndex = range.upperBound
        }*/
        //Pick one randomly
    }
    
    //Get the contents of a page
    func getPageContents(url: String) -> String {
        var page = ""
        do {
            let url = URL(string: url)
            page = try String(contentsOf: url!, encoding: .utf8)
            print("page: \(page)")
        } catch let error {
            print(error)
        }
        return page
        /*let request = URLRequest(url: url! as URL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            let pageContents = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            //print("\(self.pageContents)")
        })*/
        //print("pageContents: \(pageContents)")
        //task.resume()
    }
    
    //Returns the url of the recipe list
    func getUrl(str: String) -> String {
        let urlFormat = "https://smittenkitchen.com/recipes/sweets/"
        let urlEnd =  "/?format=list"
        var urlFixed = str
        if urlFixed.contains("/"), urlFixed != "Ice Cream/Sorbet" {
            urlFixed = urlFixed.replacingOccurrences(of: "/", with: "-")
        }
        else if urlFixed.contains(" "), urlFixed != "Ice Cream/Sorbet" {
            urlFixed = urlFixed.replacingOccurrences(of: " ", with: "-")
        }
        else if urlFixed == "Ice Cream/Sorbet" {
            urlFixed = "ice-creamsorbet"
        }
        let newUrl = urlFormat + urlFixed.lowercased() + urlEnd
        print("page: \(pageContents)")
        print("newUrl: \(newUrl)")
        if pageContents.range(of: newUrl) != nil {
            print("Url found")
        }
        else {
            print("Url not found")
        }
        return newUrl
    }
}

