//
//  AudioDetailView.swift
//  Snapie
//
//  Created by 남경민 on 2023/07/27.
//

import SwiftUI

struct AudioDetailView: View {
    @Binding var title : String
    @Binding var content : String
    @Binding var date : Date
    @Binding var totalTime : Int
    var body: some View {
        let dateString = dateformat(date: date)
        let totalTimeString = totalTimeFormat(totalSeconds: totalTime)
        VStack{
            HStack {
                VStack(alignment:.leading,spacing:5){
                    Text("\(dateString)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.grey1)
                    Text("\(totalTimeString)")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.grey1)
                }
                Spacer()
            }
            
            ScrollView{
                VStack(alignment:.leading){
                    HStack {
                        Text("\(content)")
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 14, weight: .regular))
                        Spacer()
                    }
                }
                .padding(.top, 30)
            }
            
            
        }
        .padding(.horizontal, 20)
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: BackButton())
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(title)")
                    .font(.system(size: 20, weight: .semibold))
                                    
            }
        }
       
    }
    func dateformat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.M.d E a h시 m분"

        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "오늘 a h시 m분"
        }

        let result = formatter.string(from: date)
        print(result)
        return result
    }
    func totalTimeFormat(totalSeconds: Int) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full

        let formattedString = formatter.string(from: TimeInterval(totalSeconds))
        print(formattedString ?? "")
         
        /*
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        
        let formattedString = formatter.string(from: TimeInterval(totalSeconds))
        print(formattedString ?? "")*/
        return formattedString ?? ""
        
    }
}

struct AudioDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AudioDetailView(title: .constant("새 녹음"), content: .constant("논의 사항 Meeting Minutes Meeting Name: Marketing Team Meeting Date: January 1, 2023 Time: 10:00am - 11:00am Location: Zoom Attendees: John Doe (Marketing Manager) Jane Smith (Marketing Coordinator)Alex Lee (Social Media Specialist) Samantha Green (Graphic Designer) Agenda: Review of last meeting's action items Update on ongoing marketing campaigns Discussion of new marketing campaign ideas Any other business Discussion: John reviewed the action items from the last meeting. All items were completed on time except for the social media report, which was delayed due to Alex's workload. John reminded Alex to prioritize the report. Jane provided an update on the email marketing campaign. The open rate was higher than expected, but the click-through rate was lower. Jane suggested making changes to the email content to improve engagement."), date: .constant(Date()), totalTime: .constant(3600 + 1983))
    }
}
