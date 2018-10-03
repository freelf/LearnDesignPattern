//
//  SequentialQuestionStrategy.swift
//  RabbleWabble
//
//  Created by 张东坡 on 2018/9/27.
//  Copyright © 2018年 张东坡. All rights reserved.
//

import Foundation
public class SequentialQuestionStrategy: BaseQuestionStrategy {

    
    // MARK: - Object Lifecycle
    public convenience init(questionGroupCaretaker: QuestionGroupCaretaker) {
        let questionGroup = questionGroupCaretaker.selectedQuestionGroup!
        
        let questions = questionGroup.questions
        
        self.init(questionGroupCaretaker: questionGroupCaretaker, questions: questions)
    }
    
    
}
