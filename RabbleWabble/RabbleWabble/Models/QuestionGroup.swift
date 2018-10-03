//
//  QuestionGroup.swift
//  RabbleWabble
//
//  Created by 张东坡 on 2018/8/13.
//  Copyright © 2018 张东坡. All rights reserved.
//

import Foundation
public class QuestionGroup: Codable {
    public class Score: Codable {
        public var correctCount: Int = 0
        public var incorrectCount: Int = 0
        public init() { }
    }
    public let questions: [Question]
    public let title: String
    public var score: Score
    
    public init(questions: [Question],
                score: Score = Score(),
                title: String) {
        self.questions = questions
        self.score = score
        self.title = title
    }
}
