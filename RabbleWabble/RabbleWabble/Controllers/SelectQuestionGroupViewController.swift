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
    private let questionGroupCaretaker = QuestionGroupCaretaker()
    private var questionGroups: [QuestionGroup] {
        return questionGroupCaretaker.questionGroups
    }
    private var selectedQuestionGroup: QuestionGroup! {
        get {
            return questionGroupCaretaker.selectedQuestionGroup
        }
        set {
            questionGroupCaretaker.selectedQuestionGroup = newValue
        }
    }
    private let appSettings = AppSettings.shared
    
    //MARK: - View Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        questionGroups.forEach {
            print("\($0.title): " + "correctCount \($0.score.correctCount), " + "incorrectCount \($0.score.incorrectCount)" )
        }
    }
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
        viewController.questionStrategy = appSettings.questionStrategy(for: questionGroupCaretaker)
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
