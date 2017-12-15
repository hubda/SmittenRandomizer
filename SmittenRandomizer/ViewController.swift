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
    var recipeUrl = ""
    var recipeName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        //CategoryPicker.delegate = self
        //CategoryPicker.dataSource = self
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
        /*if pickerView == CategoryPicker {
            //print("categories.count: \(categories.count)")
            return categories.count
        }*/
        //print("sweetCategory.count: \(sweetCategory.count)")
        return sweetCategory.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        /*if pickerView == CategoryPicker {
            //print("categories[row]: \(categories[row])")
            return categories[row]
        }*/
        //print("sweetcategory[row]: \(sweetCategory[row])")
        return sweetCategory[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        /*if pickerView == CategoryPicker {
            categoryPicked = categories[row]
            //print("Category: \(categories[row])")
        }*/
        if pickerView == SubcategoryPicker {
            subcategoryPicked = sweetCategory[row]
            //print("Subcategory: \(sweetCategory[row])")
        }
    }
    
    //MARK: Actions
    //Choose a random meal
    @IBAction func findRandomRecipe(_ sender: UIButton) {
        if subcategoryPicked == "" {
            subcategoryPicked = sweetCategory[0]
        }
        //Get the contents of the category page
        pageContents = getPageContents(url: categoryUrl)
        //Get the url of the recipe list from the picker
        categoryPage = getUrl(str: subcategoryPicked)
        //Get the recipe from the url
        let recipe = getRecipe(url: categoryPage)
        recipeUrl = recipe[0]
        recipeName = recipe[1]
        print("recipeName: \(recipeName)")
        MealNameButton.setTitle(recipeName, for: .normal)
    }
    
    //Go to the meal's recipe page
    @IBAction func goToRecipe(_ sender: UIButton) {
        print("Going to the meal's page")
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! UINavigationController
        let webVC = navVC.viewControllers.first as! WebViewController
        webVC.url = recipeUrl
    }
    
    //MARK: Private Functions
    func assignCategories() {
        //categories = ["Savory", "Fruit", "Sweets", "Veggies"]
        sweetCategory = ["Bars", "Brownies/Blondies", "Cake", "Candy", "Celebration Cakes", "Chocolate", "Cookie", "Crumbles/Crisps", "Doughnut", "Everyday Cakes", "Ice Cream/Sorbet", "Popsicles", "Pudding", "Tarts/Pies", "Wedding Cake"]
    }

    //Get the recipe from a url
    func getRecipe(url: String) -> [String] {
        //Get a recipe list from the recipes
        let pageContents = getPageContents(url: url)
        //print("pageContents: \(pageContents)")
        var regex: NSRegularExpression
        var recipe: [String] = []
        var chars: [Character] = []
        var adLocs: [Int] = []
        let pageArray = Array(pageContents.characters)
        let pattern = "smittenkitchen.com/[0-9]{4}/[0-9]{2}/.+/"
        let r = NSMakeRange(0, pageContents.utf16.count)
        var nameArray: [String] = []
        do {
            regex = try NSRegularExpression(pattern: pattern)
            //Use regex to find the end of the recipes section and make it the range
            let rangePattern = "div-gpt-ad-1469032223739-0"
            let rangeRegex = try NSRegularExpression(pattern: rangePattern)
            let adMatches = rangeRegex.matches(in: pageContents, range: r)
            for match in adMatches {
                let matchRange = match.range
                adLocs.append(matchRange.location)
            }
            let rangeToAd = NSMakeRange(adLocs[0] + 1, adLocs[1] - adLocs[0])
            let matches = regex.matches(in: pageContents, range: rangeToAd)
            var rememberedIndex = 0
            for match in matches {
                chars = ["h", "t", "t", "p", "s", ":", "/", "/"]
                let matchRange = match.range
                let matchSize = matchRange.length
                //Start at the beginning of the url
                loopForUrl: for i in matchRange.location..<matchRange.location + matchSize {
                    if pageArray[i] == "\"" {
                        rememberedIndex = i
                        break loopForUrl
                    }
                    chars.append(pageArray[i])
                }
                recipe.append(String(chars))
                chars = []
                
                //Start where the last loop left off
                var nameFlag = 0
                loopForName: for i in rememberedIndex..<matchRange.location + matchSize {
                    //Start of the name is after the > and the end is before the <
                    if pageArray[i] == ">", nameFlag == 0 {
                        nameFlag = 1
                    }
                    //Start of the name has begun
                    else if pageArray[i] != "<", nameFlag == 1 {
                        chars.append(pageArray[i])
                    }
                    //End of the name
                    else if pageArray[i] == "<", nameFlag == 1 {
                        break loopForName
                    }
                }
                let name = String(chars)
                let newName = name.replacingOccurrences(of: "&nbsp;", with: " ")
                nameArray.append(newName)
                chars = []
            }
            
        } catch let error {
            print(error)
        }
        
        let pickedRecipeIndex = pickRecipe(list: recipe)
        //print("Picked recipe: \(recipe[pickedRecipeIndex])")
        print("nameArray size: \(nameArray.count)")
        print("Picked recipe name: \(nameArray[pickedRecipeIndex])")
        let returnArray = [recipe[pickedRecipeIndex], nameArray[pickedRecipeIndex]]
        //print("returnArray: \(returnArray)")
        return returnArray
    }
    
    //Return a random recipe url from a list
    func pickRecipe(list: [String]) -> Int {
        let size = list.count
        let randNum = Int(arc4random_uniform(UInt32(size)))
        return randNum
    }
    
    //Get the contents of a page
    func getPageContents(url: String) -> String {
        var page = ""
        do {
            let url = URL(string: url)
            page = try String(contentsOf: url!, encoding: .utf8)
            //print("page: \(page)")
        } catch let error {
            print(error)
        }
        return page
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
        //print("page: \(pageContents)")
        //print("newUrl: \(newUrl)")
        /*if pageContents.range(of: newUrl) != nil {
            print("Url found")
        }
        else {
            print("Url not found")
        }*/
        return newUrl
    }
}

