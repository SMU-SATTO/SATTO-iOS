//
//  FriendViewModel.swift
//  SATTO
//
//  Created by 황인성 on 6/26/24.
//

import Foundation
import Moya
import Combine


class FriendViewModel: ObservableObject {
    
    private let provider = MoyaProvider<FriendAPI>()
    
    @Published var errorMessage: String?
    
    @Published var friend: Friend?
    
    @Published var follower: [Friend] = []
    @Published var following: [Friend] = []
    
    @Published var timetable: [Timetable] = []
    
    @Published var detailTimetable: DetailTimetable?
    
    
    func followRequest(studentId: String) {
        provider.request(.followRequest(studentId: studentId)) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    DispatchQueue.main.async {
//                        self.user = json
                        print("성공")
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse JSON: \(error)"
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error)"
                    print(self.errorMessage!)
                }
            }
        }
    }
    
    
    func fetchFollowerList(studentId: String) {
        provider.request(.followerList(studentId: studentId)) { result in
            switch result {
            case .success(let response):
                do {
                    print("시도")
                    
                    // 응답 데이터를 출력하여 확인
                    if let responseString = String(data: response.data, encoding: .utf8) {
                        print("응답 데이터: \(responseString)")
                    } else {
                        print("응답 데이터를 문자열로 변환할 수 없음")
                    }

                    // JSON 데이터를 파싱
                    if let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] {
                        print("JSON 파싱 성공: \(json)")
                        
                        // 여기서 result 데이터의 형식을 확인
                        if let resultData = json["result"] as? [[String: Any]] { // result가 배열일 경우
                            print("result 데이터: \(resultData)")

                            // JSON 데이터를 Friend 객체 배열로 디코딩
                            let resultJsonData = try JSONSerialization.data(withJSONObject: resultData, options: [])
                            let friendInfo = try JSONDecoder().decode([Friend].self, from: resultJsonData)
                            DispatchQueue.main.async {
                                self.follower = friendInfo
                                print("성공")
                                print(friendInfo)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.errorMessage = "Failed to parse JSON: Invalid format"
                                print("result 데이터 파싱 실패")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Failed to parse JSON: Invalid format"
                            print("JSON 파싱 실패")
                        }
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse JSON: \(error)"
                        print("JSON 파싱 중 오류: \(error)")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error)"
                    print("요청 실패: \(error)")
                }
            }
        }
    }
    
    func fetchFollowingList(studentId: String) {
        provider.request(.followingList(studentId: studentId)) { result in
            switch result {
            case .success(let response):
                do {
                    print("시도")
                    
                    // 응답 데이터를 출력하여 확인
                    if let responseString = String(data: response.data, encoding: .utf8) {
                        print("응답 데이터: \(responseString)")
                    } else {
                        print("응답 데이터를 문자열로 변환할 수 없음")
                    }

                    // JSON 데이터를 파싱
                    if let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] {
                        print("JSON 파싱 성공: \(json)")
                        
                        // 여기서 result 데이터의 형식을 확인
                        if let resultData = json["result"] as? [[String: Any]] { // result가 배열일 경우
                            print("result 데이터: \(resultData)")

                            // JSON 데이터를 Friend 객체 배열로 디코딩
                            let resultJsonData = try JSONSerialization.data(withJSONObject: resultData, options: [])
                            let friendInfo = try JSONDecoder().decode([Friend].self, from: resultJsonData)
                            DispatchQueue.main.async {
                                self.following = friendInfo
                                print("성공")
                                print(friendInfo)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.errorMessage = "Failed to parse JSON: Invalid format"
                                print("result 데이터 파싱 실패")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Failed to parse JSON: Invalid format"
                            print("JSON 파싱 실패")
                        }
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse JSON: \(error)"
                        print("JSON 파싱 중 오류: \(error)")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error)"
                    print("요청 실패: \(error)")
                }
            }
        }
    }
    
    func timetableList(studentId: String) {
        provider.request(.timetableList(studentId: studentId)) { result in
            switch result {
            case .success(let response):
                do {
                    print("시도")
                    
                    // 응답 데이터를 출력하여 확인
                    if let responseString = String(data: response.data, encoding: .utf8) {
                        print("응답 데이터: \(responseString)")
                    } else {
                        print("응답 데이터를 문자열로 변환할 수 없음")
                    }

                    // JSON 데이터를 파싱
                    if let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] {
                        print("JSON 파싱 성공: \(json)")
                        if let resultData = json["result"] as? [[String: Any]] {
                            print("result 데이터: \(resultData)")

                            // JSON 데이터를 Timetable 객체 배열로 디코딩
                            let resultJsonData = try JSONSerialization.data(withJSONObject: resultData, options: [])
                            let timetableInfo = try JSONDecoder().decode([Timetable].self, from: resultJsonData)
                            DispatchQueue.main.async {
                                self.timetable = timetableInfo
                                print("성공")
                                print(timetableInfo)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.errorMessage = "Failed to parse JSON: Invalid format"
                                print("result 데이터 파싱 실패")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Failed to parse JSON: Invalid format"
                            print("JSON 파싱 실패")
                        }
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse JSON: \(error)"
                        print("JSON 파싱 중 오류: \(error)")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error)"
                    print("요청 실패: \(error)")
                }
            }
        }
    }

    
    func myTimetableList() {
        provider.request(.myTimeTableList) { result in
            switch result {
            case .success(let response):
                do {
                    print("시도")
                    
                    // 응답 데이터를 출력하여 확인
                    if let responseString = String(data: response.data, encoding: .utf8) {
                        print("응답 데이터: \(responseString)")
                    } else {
                        print("응답 데이터를 문자열로 변환할 수 없음")
                    }

                    // JSON 데이터를 파싱
                    if let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] {
                        print("JSON 파싱 성공: \(json)")
                        if let resultData = json["result"] as? [[String: Any]] {
                            print("result 데이터: \(resultData)")

                            // JSON 데이터를 Timetable 객체 배열로 디코딩
                            let resultJsonData = try JSONSerialization.data(withJSONObject: resultData, options: [])
                            let timetableInfo = try JSONDecoder().decode([Timetable].self, from: resultJsonData)
                            DispatchQueue.main.async {
                                self.timetable = timetableInfo
                                print("성공")
                                print(timetableInfo)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.errorMessage = "Failed to parse JSON: Invalid format"
                                print("result 데이터 파싱 실패")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Failed to parse JSON: Invalid format"
                            print("JSON 파싱 실패")
                        }
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to parse JSON: \(error)"
                        print("JSON 파싱 중 오류: \(error)")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error)"
                    print("요청 실패: \(error)")
                }
            }
        }
    }
    
    func showDetailTimeTable(timeTableId: Int) {
            provider.request(.showDetailTimeTable(timeTableId: timeTableId)) { result in
                switch result {
                case .success(let response):
                    do {
                        // JSON 데이터를 파싱
                        let json = try JSONSerialization.jsonObject(with: response.data, options: [])

                        // JSON 데이터 구조 확인
                        guard let jsonDictionary = json as? [String: Any] else {
                            DispatchQueue.main.async {
                                self.errorMessage = "Failed to parse JSON: Invalid format"
                                print("JSON 파싱 실패: JSON이 딕셔너리 형식이 아님")
                            }
                            return
                        }

                        // "result" 키가 있는지 확인
                        guard let resultObject = jsonDictionary["result"] as? [String: Any] else {
                            DispatchQueue.main.async {
                                self.errorMessage = "Failed to parse JSON: 'result' key not found or invalid format"
                                print("result 데이터 파싱 실패: 'result' 키를 찾을 수 없거나 형식이 잘못됨")
                            }
                            return
                        }

                        // JSON 데이터를 DetailTimetable 객체로 디코딩
                        let jsonData = try JSONSerialization.data(withJSONObject: resultObject, options: [])
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase // JSON의 snake_case를 camelCase로 변환
                        let timetableInfo = try decoder.decode(DetailTimetable.self, from: jsonData)

                        DispatchQueue.main.async {
                            self.detailTimetable = timetableInfo
                            print("성공")
                            print(timetableInfo)
                        }

                    } catch let error {
                        DispatchQueue.main.async {
                            self.errorMessage = "Failed to parse JSON: \(error)"
                            print("JSON 파싱 중 오류: \(error)")
                        }
                    }

                case .failure(let error):
                    DispatchQueue.main.async {
                        self.errorMessage = "Error: \(error)"
                        print("요청 실패: \(error)")
                    }
                }
            }
        }

    
}
