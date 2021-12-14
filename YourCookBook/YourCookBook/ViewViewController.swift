//
//  ViewViewController.swift
//  ViewViewController
//
//

import UIKit
import RealmSwift
class ViewViewController: UIViewController {

    
    public var currRecipe: Recipe?
    
    public var deletionHandler: (() -> Void)?
    private let realm = try! Realm()
    
    
    @IBOutlet var recipeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var recipePrepTimeLabel: UILabel!
    @IBOutlet var recipeCookTimeLabel: UILabel!
    @IBOutlet var recipeCategoryLabel: UILabel!
    @IBOutlet var recipeIngredientsLabel: UILabel!
    @IBOutlet var recipeStepsLabel: UITextView!

    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeLabel.text = currRecipe?.recipeName
        descriptionLabel.text = currRecipe?.recipeDescription
        dateLabel.text = Self.dateFormatter.string(from: currRecipe!.date)
        recipePrepTimeLabel.text = currRecipe?.recipePrepTime
        recipeCookTimeLabel.text = currRecipe?.recipeCookTime
        recipeCategoryLabel.text = currRecipe?.recipeCategory
        recipeIngredientsLabel.text = currRecipe?.recipeIngredients
        recipeStepsLabel.text = currRecipe?.recipeSteps

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
        // Do any additional setup after loading the view.
    }
    
    @objc private func didTapDelete() {
        guard let myRecipe = self.currRecipe else{
            return
        }
        realm.beginWrite()
        realm.delete(myRecipe)
        try! realm.commitWrite()
        deletionHandler?()
        navigationController?.popToRootViewController(animated: true)
    }
}
