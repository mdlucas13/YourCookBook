//
//  ViewController.swift
//  CookBook
//



import RealmSwift
import UIKit


class Recipe: Object {
    @objc dynamic var recipeName: String = ""
    @objc dynamic var recipeDescription: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var recipePrepTime: String = ""
    @objc dynamic var recipeCookTime: String = ""
    @objc dynamic var recipeCategory: String = ""
    @objc dynamic var recipeIngredients: String = ""
    @objc dynamic var recipeSteps: String = ""
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    
    private let realm = try! Realm()
    private var data = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(Recipe.self)
            .sorted(byKeyPath: "recipeName", ascending: true)
            .map({$0})
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].recipeName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //open screen where we can see item info
        let item = data[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(identifier: "view") as? ViewViewController else{
            return
        }
        vc.currRecipe = item
        vc.deletionHandler = { [weak self] in
            self?.refresh()
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = item.recipeName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapAddButton(){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "enter") as? EntryViewController else{
            return
        }
        vc.completionHandler = { [weak self] in
            self?.refresh()
        }
        vc.title = "New Recipe"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func refresh(){
        data = realm.objects(Recipe.self)
            .sorted(byKeyPath: "recipeName", ascending: true)
            .map({$0})
        table.reloadData()
    }
}

