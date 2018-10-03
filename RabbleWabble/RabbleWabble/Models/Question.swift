//
//  Question.swift
//  RabbleWabble
//
//  Created by 张东坡 on 2018/8/13.
//  Copyright © 2018 张东坡. All rights reserved.
//

import Foundation
public class Question: Codable {
    public let answer: String
    public let hint: String?
    public let prompt: String
    public init(answer: String, hint: String?, prompt: String) {
        self.answer = answer
        self.hint = hint
        self.prompt = prompt
    }
}
