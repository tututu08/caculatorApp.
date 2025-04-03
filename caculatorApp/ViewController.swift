//  ViewController.swift
//  calculatorApp
//
//  Created by 강성훈 on 3/28/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let label = UILabel()
    let verticalStack = UIStackView() // button함수에서 사용할수가 없어 전역으로 이동
    var horizonStacks: [UIStackView] = [] // let으로 선언했더니 에러남. var로 수정
    let titles = [
        ["7", "8", "9", "+",],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "*"],
        ["AC", "0", "=", "/"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        labelConfigureUI()
        stackConfigure() // 순서 때문에 에러발생 버튼 - 스택뷰 순서 바꿔줌.
        buttonConfigureUI()
        
    }
    
    //label 만드는 메서드
    private func labelConfigureUI() {
        label.textColor = .white
        label.text = "0"
        
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textAlignment = .right
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.trailing.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalToSuperview().inset(200)
        }
    }
    
    //stackview만드는 메서드
    private func stackConfigure(){
        verticalStack.axis = .vertical
        verticalStack.backgroundColor = .black
        verticalStack.spacing = 10
        verticalStack.distribution = .fillEqually
        view.addSubview(verticalStack)
        // 내부에 for문으로 4개의 horizon만들기.
        verticalStack.snp.makeConstraints {
            $0.width.equalTo(350)
            $0.top.equalTo(label.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            
        }
        for _ in 0..<4 {
            let horizonStack = UIStackView()
            horizonStack.axis = .horizontal
            horizonStack.backgroundColor = .black
            horizonStack.spacing = 10
            horizonStack.distribution = .fillEqually
            
            verticalStack.addArrangedSubview(horizonStack)//verticalstackview에 하나씩 추가하기
            horizonStacks.append(horizonStack)
        }
    }
    
    //버튼생성 및 속성부여하는 메서드
    private func buttonConfigureUI() {
        //소괄호는 튜플로 선언, 배열인 중괄호로 변경함
        for (i, line) in titles.enumerated() { // (인덱스, 값)으로 순회시켜주고 한번 더 돌리기 / [7,8,9,+],[4,5,6,-]...이런형태로 풀어줌. 여기서 i가 각 배열의 인덱스로.
            for (j, title) in line.enumerated() { //이제 앞선 i의 [0]에 해당하는 인덱스의 값인 7,8,9,+형태로 풀어줌. 그럼 "7"은 [0][0]의 인덱스를 가지게된다.
                //print("title: \(title), index: [\(i)][\(j)]")
                let buttons = UIButton()
                //이렇게 값으로 접근할 수도 있고,
                //let orangebutton = ["+","-"]
                //if orangebutton.contains(title) {
                //인덱스로 접근하기 위해서 해봄
                //if titles[0][3] == "+" { //항상 참이기때문에 빌드싪
                if i == 0 && j == 3 || i == 1 && j == 3 || i == 2 && j == 3 || i == 3 && j == 0 || i == 3 && j == 2 || i == 3 && j == 3  {
                    buttons.setTitle(title, for: .normal)
                    buttons.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
                    buttons.backgroundColor = UIColor(.orange)
                    buttons.layer.cornerRadius = 40
                    buttons.addTarget(self, action: #selector(buttonsclick), for: .touchDown)
                    horizonStacks[i].addArrangedSubview(buttons) //append로 하니까 에러남.
                    //stackViews.addArrangedSubview(buttons) //view.addArrangedSubview로 설정해서 에러남. 스택뷰에 연결해주기위해 수정함.
                    //                    print("버튼텍스트: \(title)")
                    buttons.snp.makeConstraints { make in
                        make.height.equalTo(80)
                        make.width.equalTo(80)
                    }
                } else {
                    //title을 변수로 넣어줳기 때문에 오류 발생(배열이 들어감), 각각의 텍스트인 firbutton으로 수정함.
                    buttons.setTitle(title, for: .normal)
                    buttons.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
                    buttons.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)
                    buttons.layer.cornerRadius = 40
                    buttons.addTarget(self, action: #selector(buttonsclick), for: .touchUpInside)
                    //디버깅용
                    //print("버튼텍스트: \(title)")
                    buttons.snp.makeConstraints { make in
                        make.height.equalTo(80)
                        make.width.equalTo(80)
                        horizonStacks[i].addArrangedSubview(buttons) //append로 하니까 에러남.
                        //stackViews.addArrangedSubview(buttons) //view.addArrangedSubview로 설정해서 에러남. 스택뷰에 연결해주기위해 수정함.
                    }
                }
            }
        }
    }
    
    //버튼 액션 함수
    //    func continuousOperate(expression: String) -> Bool{
    //        let pattern = #"[-+*/]"#
    //    }
    //
    
    func calculate(expression: String) -> Int? {
        let expression = NSExpression(format: expression)
        if let result = expression.expressionValue(with: nil, context: nil) as? Int {
            return result
        } else {
            return nil
        }
        
    }
    /* 예외처리 할거
     무슨 상황에서든 크래쉬나지 않도록!!
     연산자 두개 중복 방지 .
     0입력시 연산자가 앞에 있으면 무효처리.
     피연산자가 없을때(nill) = 버튼 입력시 무효처리.
     */
    
    @objc func buttonsclick(_ sender: UIButton){
        guard let title = sender.currentTitle else {return}
        let lastChar = label.text?.last.map { String($0) } //
        let operators = ["-","+","*","/"]
        //AC을 입력했을때, 0으로 초기화.
        if title == "AC" {
            label.text = "0"
            return
        }
        // =을 입력했을때,
        else if title == "=" {
            if let lastChar, operators.contains(lastChar) { // Nill값을 계산하면 무효.
                return
            }
            else if let expression = label.text, //정상값이면 정상 연산 처리.
                    let result = calculate(expression: expression){
                label.text = "\(result)"
            }
        }
        //연산자를 입력했을때,
        else if operators.contains(title) {
            if let lastChar, operators.contains(lastChar) { // 마지막 글자가 연산자일때(연산자 중복일때) 삭제 후, 추가
                label.text?.removeLast()
            }
            label.text?.append(title)
            return
        }
        // 0을 입력했을때,
        else if title == "0" { //마지막 글자가 연산자이면 무효처리.
            if let lastChar, operators.contains(lastChar) {
                return
            }
            label.text?.append(title)
        }
        // 값이 0 뿐일때(초기상태일때)
        else if label.text == "0" {
            label.text = ""
            label.text?.append(title)
            return
        }
        //기본 숫자 입력일때
        else{
            label.text?.append(title)
            return
        }
    }
}

