//
//  ViewController.swift
//  RabbleWabble
//
//  Created by 张东坡 on 2018/8/13.
//  Copyright © 2018 张东坡. All rights reserved.
//

import UIKit

//MARK: - QuestionViewControllerDelegate
protocol QuestionViewControllerDelegate: class {
    func questionViewController(_ viewController: QuestionViewControlle,
                                didCancel questionGroup: QuestionGroup,
                                at questionIndex: Int)
    // 当用户完成了一个questionGroup
    func questionViewController(_ viewController: QuestionViewControlle,
                                didComplete questionGroup: QuestionGroup)
}
class QuestionViewControlle: UIViewController {
    // MARK: - Instance Properties
    public var questionGroup: QuestionGroup! {
        didSet {
            navigationItem.title = questionGroup.title
        }
    }
    public var questionIndex = 0
    
    public var correctCount = 0
    public var incorrectCount = 0
    public var delegate: QuestionViewControllerDelegate?
    public var questionView: QuestionView! {
        guard isViewLoaded else { return nil }
        return view as! QuestionView
    }
    private lazy var questionIndexItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "",
                                   style: .plain,
                                   target: nil,
                                   action: nil)
        item.tintColor = .black
        navigationItem.rightBarButtonItem = item
        return item
    }()
    // MARK: - View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCancelButton()
        showQuestion()
    }
    private func setupCancelButton() {
        let action = #selector(handleCancelPressed(sender:))
        let image = UIImage(named: "ic_menu")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                           landscapeImagePhone: nil,
                                                           style: .plain,
                                                           target: self, action: action)
    }
    @objc private func handleCancelPressed(sender: UIBarButtonItem) {
        delegate?.questionViewController(self,
                                         didCancel: questionGroup,
                                         at: questionIndex)
    }
    private func showQuestion() {
        let question = questionGroup.questions[questionIndex]
        
        questionView.answerLabel.text = question.answer
        questionView.promptLabel.text = question.prompt
        questionView.hintLabel.text = question.hint
        
        questionView.answerLabel.isHidden = true
        questionView.hintLabel.isHidden = true
        questionIndexItem.title = "\(questionIndex + 1)/\(questionGroup.questions.count)"
    }
    @IBAction func toggleAnswerLabels(_ sender: Any) {
        questionView.answerLabel.isHidden =
            !questionView.answerLabel.isHidden
        questionView.hintLabel.isHidden =
            !questionView.hintLabel.isHidden
    }
    // 1
    @IBAction func handleCorrect(_ sender: Any) {
        correctCount += 1
        questionView.correctCountLabel.text = "\(correctCount)"
        showNextQuestion()
    }
    
    // 2
    @IBAction func handleIncorrect(_ sender: Any) {
        incorrectCount += 1
        questionView.incorrectCountLabel.text = "\(incorrectCount)"
        showNextQuestion()
    }
    
    // 3
    private func showNextQuestion() {
        questionIndex += 1
        guard questionIndex < questionGroup.questions.count else {
            delegate?.questionViewController(self,
                                             didComplete: questionGroup)
            return
        }
        showQuestion()
    }
}

