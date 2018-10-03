//
//  RandomQuestionStrategy.swift
//  RabbleWabble
//
//  Created by 张东坡 on 2018/9/27.
//  Copyright © 2018年 张东坡. All rights reserved.
//

import Foundation
// 1
import GameplayKit.GKRandomSource

public class RandomQuestionStrategy: BaseQuestionStrategy {
    
    // MARK: - Object Lifecycle
    public convenience init(questionGroupCaretaker: QuestionGroupCaretaker) {
        
        let questionGroup = questionGroupCaretaker.selectedQuestionGroup!
        
        // 2
        let randomSource = GKRandomSource.sharedRandom()
        let questions =
            randomSource.arrayByShufflingObjects(
                in: questionGroup.questions) as! [Question]
        self.init(questionGroupCaretaker: questionGroupCaretaker, questions: questions)
    }
}
