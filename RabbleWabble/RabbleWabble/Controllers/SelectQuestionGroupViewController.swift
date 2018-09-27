//
//  SelectQuestionGroupViewController.swift
//  RabbleWabble
//
//  Created by Beyond on 2018/8/21.
//  Copyright © 2018年 张东坡. All rights reserved.
//

import UIKit

public class SelectQuestionGroupViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet internal var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    //MARK: - Properties
    public let questionGroups = QuestionGroup.allGroups()
    private var selectedQuestionGroup: QuestionGroup!
}
//MARK: - UITableViewDataSource
extension SelectQuestionGroupViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionGroups.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionGroupCell", for: indexPath) as! QuestionGroupCell
        let questionGroup = questionGroups[indexPath.row]
        cell.titleLabel.text = questionGroup.title
        return cell
    }
}
//MARK: - UITableViewDelegate
extension SelectQuestionGroupViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        //需要在这个方法赋值，因为didSelected 方法是在触发 segue 之后执行的。
        selectedQuestionGroup = questionGroups[indexPath.row]
        return indexPath
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? QuestionViewController else { return }
        viewController.delegate = self
        viewController.questionStrategy = RandomQuestionStrategy(questionGroup: selectedQuestionGroup)
    }
}
//MARK: - QuestionViewControllerDelegate
extension SelectQuestionGroupViewController: QuestionViewControllerDelegate {
    func questionViewController(
        _ viewController: QuestionViewController,
        didCancel questionGroup: QuestionStrategy) {
        navigationController?.popToViewController(self,
                                                  animated: true)
    }
    
    func questionViewController(
        _ viewController: QuestionViewController,
        didComplete questionGroup: QuestionStrategy) {
        navigationController?.popToViewController(self,
                                                  animated: true)
    }
    
}
