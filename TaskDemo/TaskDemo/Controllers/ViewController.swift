//
//  ViewController.swift
//  TaskDemo
//
//  Created by Niket on 22/05/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    func setupView() {
        let btnEntry = UIButton()
        btnEntry.setTitle("ENTER", for: .normal)
        btnEntry.setTitleColor(.black, for: .normal)
        btnEntry.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 80, height: 30)
        btnEntry.center = self.view.center
        btnEntry.addTarget(self, action: #selector(btnEntryPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(btnEntry)
    }

    @objc func btnEntryPressed(sender: UIButton) {
        debugPrint("Entry clicked")
        let vc = TasksViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

