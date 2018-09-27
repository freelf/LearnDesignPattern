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
    func questionViewController(
        _ viewController: QuestionViewController,
        didCancel questionGroup: QuestionStrategy)
    
    func questionViewController(
        _ viewController: QuestionViewController,
        didComplete questionStrategy: QuestionStrategy)
}
class QuestionViewController: UIViewController {
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
    public var questionStrategy: QuestionStrategy! {
        didSet {
            navigationItem.title = questionStrategy.title
        }
    }
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
            didCancel: questionStrategy)
    }
    private func showQuestion() {
        // 1
        let question = questionStrategy.currentQuestion()
        
        questionView.answerLabel.text = question.answer
        questionView.promptLabel.text = question.prompt
        questionView.hintLabel.text = question.hint
        
        questionView.answerLabel.isHidden = true
        questionView.hintLabel.isHidden = true
        
        // 2
        questionIndexItem.title =
            questionStrategy.questionIndexTitle()
    }
    @IBAction func toggleAnswerLabels(_ sender: Any) {
        questionView.answerLabel.isHidden =
            !questionView.answerLabel.isHidden
        questionView.hintLabel.isHidden =
            !questionView.hintLabel.isHidden
    }
    // 1
    @IBAction func handleCorrect(_ sender: Any) {
        let question = questionStrategy.currentQuestion()
        questionStrategy.markQuestionCorrect(question)
        
        questionView.correctCountLabel.text =
            String(questionStrategy.correctCount)
        showNextQuestion()
    }
    
    // 2
    @IBAction func handleIncorrect(_ sender: Any) {
        let question = questionStrategy.currentQuestion()
        questionStrategy.markQuestionIncorrect(question)
        
        questionView.incorrectCountLabel.text =
            String(questionStrategy.incorrectCount)
        showNextQuestion()
    }
    
    // 3
    private func showNextQuestion() {
        guard questionStrategy.advanceToNextQuestion() else {
            delegate?.questionViewController(self,
                                             didComplete: questionStrategy)
            return
        }
        showQuestion()
    }
}

