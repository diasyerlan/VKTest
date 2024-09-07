//
//  ViewController.swift
//  VKTestApp
//
//  Created by Dias Yerlan on 03.09.2024.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    var childViewController: UIViewController?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with viewController: UIViewController, parentViewController: UIViewController) {
            // Remove the previous view controller's view if it's present
            if let childView = childViewController?.view {
                childView.removeFromSuperview()
            }
            
            // Store the reference of the new view controller
            self.childViewController = viewController

            // Add the child view controller to the parent
            parentViewController.addChild(viewController)

            // Add the child view controller's view to the cell's contentView
            viewController.view.frame = contentView.bounds
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentView.addSubview(viewController.view)

            // Notify that the child has been added
            viewController.didMove(toParent: parentViewController)
        }
    
    func configure(withStoryboardID storyboardID: String, from storyboard: UIStoryboard, parentViewController: UIViewController) {
            // Remove the previous view controller's view if it exists
            if let childView = childViewController?.view {
                childView.removeFromSuperview()
            }
            
            // Instantiate the child view controller from storyboard
            let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
            
            // Store the reference to the child view controller
            self.childViewController = viewController

            // Add the child view controller to the parent
            parentViewController.addChild(viewController)

            // Add the child view controller's view to the cell's contentView
            viewController.view.frame = contentView.bounds
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentView.addSubview(viewController.view)

            // Notify that the child has been added
            viewController.didMove(toParent: parentViewController)
        }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Remove the child view controller's view before reuse
        if let childView = childViewController?.view {
            childView.removeFromSuperview()
            childViewController?.willMove(toParent: nil)
            childViewController?.removeFromParent()
        }
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    var smallMode = false
    
    let viewControllers: [(name: String, viewController: UIViewController.Type)] = [
        ("Current weather", WeatherViewController.self),
        ("Current city", LocationViewController.self),
        ("Tic Tac Toe", TicTacToeViewController.self),
        ("Current weather", WeatherViewController.self),
        ("Current city", LocationViewController.self),
        ("Tic Tac Toe", TicTacToeViewController.self),
        ("Current weather", WeatherViewController.self),
        ("Current city", LocationViewController.self),
        ("Tic Tac Toe", TicTacToeViewController.self),
        ("Current weather", WeatherViewController.self),
        ("Current city", LocationViewController.self),
        ("Tic Tac Toe", TicTacToeViewController.self),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureButton()
    }
    
    func configureTableView() {
        tableView = UITableView(frame: self.view.bounds)
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = smallMode ? view.bounds.height / 8 : view.bounds.height / 2
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")

    }
    
    func configureButton() {
        let button = UIBarButtonItem(image: UIImage(systemName: "square.stack.3d.up.fill"), style: .plain, target: self, action: #selector(buttonTapped))
        button.tintColor = .gray
        navigationItem.rightBarButtonItem = button
    }
    @objc func buttonTapped() {
        smallMode.toggle()
        tableView.rowHeight = smallMode ? view.bounds.height / 8 : view.bounds.height / 2 // Update row height
        tableView.reloadData() // Reload table view to apply changes
        print(smallMode)
    }
    let storyboardInstance = UIStoryboard(name: "Main", bundle: nil) // Assuming "Main" is the name of your storyboard

    
}

extension ViewController {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if smallMode {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")

            cell.textLabel?.text = viewControllers[indexPath.row].name
            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else {
                        return UITableViewCell()
                    }

                    // Create a new ChildViewController
            let childVC = viewControllers[indexPath.row].viewController.init()

                    // Configure the cell with the view controller
            if viewControllers[indexPath.row].viewController == TicTacToeViewController.self {
                print("here")
                cell.configure(withStoryboardID: "second", from: storyboardInstance, parentViewController: self)
            } else {
                cell.configure(with: childVC, parentViewController: self)
            }

                    return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if smallMode {
            let vcType = viewControllers[indexPath.row].viewController
            if vcType == TicTacToeViewController.self {
                guard let vc = storyboard?.instantiateViewController(withIdentifier: "second") as? TicTacToeViewController else {
                    print("failed to get vc")
                    return }
                navigationController?.pushViewController(vc, animated: true)
            }
            else {
                let vc = vcType.init()
                vc.title = viewControllers[indexPath.row].name
                navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
}
