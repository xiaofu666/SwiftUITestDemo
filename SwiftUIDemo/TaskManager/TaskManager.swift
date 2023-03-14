//
//  TaskManager.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/2/23.
//

import SwiftUI

struct TaskModel: Identifiable {
    var id: UUID = .init()
    var dateAdded: Date
    var taskName: String
    var taskDescription: String
    var taskCategory: Category
}


var SampleTasks: [TaskModel] = [
    .init(dateAdded: Date(timeIntervalSince1970: 1677160038), taskName: "学习编程", taskDescription: "完事睡觉", taskCategory: .bug),
    .init(dateAdded: Date(timeIntervalSince1970: 1677156738), taskName: "Edit YT Video", taskDescription: "ceshi", taskCategory: .general)
]

enum Category: String,CaseIterable {
    case general = "General"
    case bug = "Bug"
    case idea = "Idea"
    case modifiers = "Modifiers"
    case challenge = "Challenge"
    case coding = "Coding"
    
    var color: Color {
        switch self {
        case .general:
            return Color("Gray")
        case .bug:
            return Color("Green")
        case .idea:
            return Color("Pink")
        case .modifiers:
            return Color("Blue")
        case .challenge:
            return Color("Purple")
        case .coding:
            return Color.brown
        }
    }
}

struct TaskManager: View {
    @State var currentDay: Date = .init()
    @State var tasks: [TaskModel] = SampleTasks
    @State var addNewTask: Bool = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            TimeLineView()
                .padding(15)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            HeaderView()
        }
        .fullScreenCover(isPresented: $addNewTask) {
            AddTaskView{ task in
                tasks.append(task)
            }
        }

    }
    
    @ViewBuilder
    func TimeLineView() -> some View {
        ScrollViewReader { proxy in
            let hours = Calendar.current.hours
            let midHour = hours[hours.count / 2]
            VStack(alignment: .leading) {
                ForEach(Calendar.current.hours, id: \.self) { hour in
                    TimeLineViewRow(hour)
                        .id(hour)
                }
            }
            .onAppear {
                proxy.scrollTo(midHour)
            }
        }
    }
    
    @ViewBuilder
    func TimeLineViewRow(_ date: Date) -> some View {
        HStack {
            Text(date.toString("h a"))
                .ubuntu(14, .regular)
                .frame(width: 45, alignment: .leading)
            
            let calendar = Calendar.current
            let filteredTasks = tasks.filter {
                if let hour = calendar.dateComponents([.hour], from: date).hour, let taskHour = calendar.dateComponents([.hour], from: $0.dateAdded).hour, hour == taskHour && calendar.isDate($0.dateAdded, inSameDayAs: currentDay) {
                    return true
                }
                return false
            }
            
            if filteredTasks.isEmpty {
                Rectangle()
                    .stroke(.gray.opacity(0.5), style: StrokeStyle(lineWidth: 0.5, lineCap: .butt, lineJoin: .bevel, dash: [5],dashPhase: 5))
                    .frame(height: 0.5)
                    .offset(y: 10)
            } else {
                /// - Task view
                VStack (spacing: 0) {
                    ForEach(filteredTasks) { task in
                        TaskRow(task)
                    }
                }
            }
            
        }
        .hAligm(.leading)
        .padding(.vertical, 15)
    }
    
    @ViewBuilder
    func TaskRow(_ task: TaskModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.taskName)
                .ubuntu(16, .regular)
                .foregroundColor(task.taskCategory.color)
            if task.taskDescription != "" {
                Text(task.taskDescription)
                    .ubuntu(14, .light)
                    .foregroundColor(task.taskCategory.color.opacity(0.5))
            }
        }
        .hAligm(.leading)
        .padding(12)
        .background {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(task.taskCategory.color)
                    .frame(width: 5)
                
                Rectangle()
                    .fill(task.taskCategory.color.opacity(0.35))
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Today")
                        .ubuntu(30, .light)
                    Text("Welcome to task node")
                        .ubuntu(14, .light)
                }
                .hAligm(.leading)
                
                Button {
                    addNewTask.toggle()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus")
                        Text("Add Task")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background() {
                        Capsule()
                            .fill(Color("Blue").gradient)
                    }
                    .foregroundColor(.white)
                }

            }
            
            Text(Date().toString("MMM YYYY"))
                .ubuntu(16, .medium)
                .hAligm(.leading)
                .padding(.top, 15)
            
            WeekRow()
        }
        .padding(15)
        .background {
            VStack(spacing: 0) {
                Color("White")
                
                Rectangle()
                    .fill(.linearGradient(colors: [
                        Color("White"),
                        .clear
                    ], startPoint: .top, endPoint: .bottom))
                    .frame(height: 20)
            }
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func WeekRow() -> some View {
        HStack(spacing: 0) {
            ForEach(Calendar.current.currentWeek) { weekDay in
                let status = Calendar.current.isDate(weekDay.date, inSameDayAs: currentDay)
                
                VStack {
                    Text(weekDay.string.prefix(3))
                        .ubuntu(12, .medium)
                    Text(weekDay.date.toString("dd"))
                        .ubuntu(16, status ? .medium : .regular)
                }
                .foregroundColor(status ? Color("Blue") : .gray)
                .hAligm(.center)
                .containerShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeIn(duration: 0.3)) {
                        currentDay = weekDay.date
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, -15)
    }
}

struct TaskManager_Previews: PreviewProvider {
    static var previews: some View {
        TaskManager()
            .preferredColorScheme(.light)
    }
}
