 import UIKit
 //outlook
 import MSGraphClientSDK
 import MSGraphClientModels
 //Google
 import GoogleAPIClientForREST
 import GoogleSignIn
 import GTMSessionFetcher
 //Apple
 import EventKit
 
 class MainViewController: UIViewController {
    private let scopes = [kGTLRAuthScopeCalendar]
     private let service = GTLRCalendarService()
    // private let spinner = SpinnerViewController()
    var calendarId = ""
    var token = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // See if a user is already signed in
        //         spinner.start(container: self)
        
//        AuthenticationManager.instance.getTokenSilently {
//            (token: String?, error: Error?) in
//            
//            DispatchQueue.main.async {
//                //                 self.spinner.stop()
//                
//                guard let _ = token, error == nil else {
//                    // If there is no token or if there's an error,
//                    // no user is signed in, so stay here
//                    return
//                }
//                
//                // Since we got a token, a user is signed in
//                // Go to welcome page
//                self.performSegue(withIdentifier: "userSignedIn", sender: nil)
//            }
//        }
        GIDSignIn.sharedInstance().clientID = "869556618508-cfup3e2uapcih6kcanfeacq7rl0hpri9.apps.googleusercontent.com"
             GIDSignIn.sharedInstance().delegate = self
             GIDSignIn.sharedInstance().scopes = scopes
             GIDSignIn.sharedInstance()?.presentingViewController = self
        /////
//        let url = URL(string: "http://api.aladhan.com/v1/calendar?latitude=30.052932&longitude=31.235802&method=5&month=4&year=2020")
        let url = URL(string: "https://muslimsalat.com/cairo/yearly/22-03-2020/true/1.json?key=48ae8106ef6b55e5dac258c0c8d2e224")
        if let final_url = url{
        dataRequest(FINAL_URL:final_url)
        }
    }
    func dataRequest (FINAL_URL : URL) {
        
//        if Reachability.isConnectedToNetwork(){
            
            let task = URLSession.shared.dataTask(with: FINAL_URL){
                (data,response,error) in
                
                if let URLresponse = response {
                    print(URLresponse)
                }
                if let URLerror = error {
                    print(URLerror)
                }
                if let URLdata = data {
                    print(URLdata)
                    do{
                        let prayerTimes = try JSONDecoder().decode(PrayerTimes.self, from: URLdata)
                        print(prayerTimes.items?[0].dateFor)
                      
                    }catch {
                        print("Error: \(error)")
                    }
//                    self.PRAYER_DATA_HANDLEROB = PrayerTimeHandler.init(_data: URLdata)
//                    self.PRAYER_DATA_HANDLEROB.decodeData()
//
//                    let delay = DispatchTime.now() + 1
//                    DispatchQueue.main.asyncAfter(deadline: delay, execute: {
//                        self.wayToDisplayData()
//                    })
                    
                }
            }
            
            task.resume()
            
//        }else{
//
//
//            let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: .alert)
//
//            let cancel = UIAlertAction(title: "Ok", style: .cancel) { (UIAlertAction) in
//
//                self.dismiss(animated: false, completion: nil)
//                self.cityTxtOL.text?.removeAll()
//            }
//
//            alert.addAction(cancel)
//
//            present(alert, animated: true, completion: nil)
//        }
    }
    //MARK:Microsoft Calendar
    @IBAction func signInMicrosoftAccount() {
        //         spinner.start(container: self)
        
        // Do an interactive sign in
        AuthenticationManager.instance.getTokenInteractively(parentView: self) {
            (token: String?, error: Error?) in
            
            DispatchQueue.main.async {
                //                 self.spinner.stop()
                
                guard let _ = token, error == nil else {
                    // Show the error and stay on the sign-in page
                    let alert = UIAlertController(title: "Error signing in",
                                                  message: error.debugDescription,
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                
                // Signed in successfully
                // Go to welcome page
                self.token = token!
//                self.createEvent(token:token!)
                self.getCalenderID(token: self.token)
                self.performSegue(withIdentifier: "userSignedIn", sender: nil)
            }
        }
    }
    func getCalenderID(token:String){
        let httpClient = MSClientFactory.createHTTPClient(with: AuthenticationManager.instance)

        let MSGraphBaseURL = "https://graph.microsoft.com/v1.0/"
        var urlRequest: NSMutableURLRequest? = nil
        if let url = URL(string: MSGraphBaseURL + ("/me/calendar")) {
            urlRequest = NSMutableURLRequest(url: url)
        }
        urlRequest?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest?.httpMethod = "GET"

        var meDataTask: MSURLSessionDataTask? = nil
        if let urlRequest = urlRequest {
            meDataTask = httpClient?.dataTask(with: urlRequest, completionHandler: { data, response, nserror in

                var calendar: MSGraphCalendar? = nil
                do {
                    if let data = data {
                        calendar = try MSGraphCalendar(data: data)
                        if let id = calendar?.entityId{
                            self.calendarId = id
                            self.createEvent(token: self.token)
//                            self.createEventList(token: self.token)
                            
                        }
                    }
                } catch let nserror {
                    print(nserror)
                }

            })
        }

        meDataTask?.execute()

    }
    func createEvent(token:String){
        //  Converted to Swift 5.1 by Swiftify v5.1.22917 - https://objectivec2swift.com/
        let httpClient = MSClientFactory.createHTTPClient(with: AuthenticationManager.instance)
        
        let MSGraphBaseURL = "https://graph.microsoft.com/v1.0/"
        var urlRequest: NSMutableURLRequest? = nil
//        #error("the path is /calendars/ not /calendar/")
//        #error("pass calendar id to the path parameters")
        if let url = URL(string: MSGraphBaseURL + ("me/calendars/" + "\(self.calendarId)" + "/events")) {
            urlRequest = NSMutableURLRequest(url: url)
        }
        urlRequest?.httpMethod = "POST"
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//       urlRequest?.setValue("\(token)", forHTTPHeaderField: "Authorization")
        let event = MSGraphEvent()

        event.subject = "Let's go for lunch"
//        let body = MSGraphItemBody()
//        body.contentType = MSGraphBodyType.html()
//        body.content = "Does mid month work for you?"
        event.body?.contentType = MSGraphBodyType.html()
        event.body?.content="Does mid month work for you?"
        //    let start = MSGraphDateTimeTimeZone()
        //    start.dateTime = "2020-03-02T12:00:00"
        //    start.timeZone = "Pacific Standard Time"
        //    event.start = start
        event.start?.dateTime="2020-03-03T8:00:00"
        event.start?.timeZone="Pacific Standard Time"
        //    let end = MSGraphDateTimeTimeZone()
        //    end.dateTime = "2020-03-02T14:00:00"
        //    end.timeZone = "Pacific Standard Time"
        event.end?.dateTime="2020-03-03T9:00:00"
        event.end?.timeZone="Pacific Standard Time"
        
//        let location = MSGraphLocation()
//        location.displayName = "Harry's Bar"
//        event.location?.displayName = "Harry's Bar"
//        var attendeesList: [AnyHashable] = []
//        let attendees = MSGraphAttendee()
//        let emailAddress = MSGraphEmailAddress()
//        emailAddress.address = "eman.shedeed@outlook.com"
//        emailAddress.name = "Adele Vance"
//        attendees.emailAddress = emailAddress
//        attendees.type = MSGraphAttendeeType.required()
//        attendeesList.append(attendees)
//        event.attendees = attendeesList
        do{
            let eventData = try event.getSerializedData()
            print(eventData)
            urlRequest?.httpBody = eventData
        }
        catch {
            print(error)
        }
        
        var meDataTask: MSURLSessionDataTask? = nil
        if let urlRequest = urlRequest {
            meDataTask = httpClient?.dataTask(with: urlRequest, completionHandler: { data, response, nserror in
                //Request Completed
                print("event added")
                
            })
        }
        
        
        meDataTask?.execute()
        
    }
    func createEventList(token:String){
         let httpClient = MSClientFactory.createHTTPClient(with: AuthenticationManager.instance)

        let MSGraphBaseURL = "https://graph.microsoft.com/v1.0/"
        var urlRequest: NSMutableURLRequest? = nil
        if let url = URL(string: MSGraphBaseURL + ("me/calendars/" + "\(self.calendarId)" + "/events")) {
                   urlRequest = NSMutableURLRequest(url: url)
        }
        urlRequest?.httpMethod = "POST"
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
     urlRequest?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let event = MSGraphEvent()
        event.subject = "test"
//        let body = MSGraphItemBody()
//        body.contentType = MSGraphBodyType.html()
//        body.content = "Does noon time work for you?"
//        event.body = body
        event.body?.contentType = MSGraphBodyType.html()
        event.body?.content="Does mid month work for you?"
//        let start = MSGraphDateTimeTimeZone()
//        start.dateTime = "2017-09-04T12:00:00"
//        start.timeZone = "Pacific Standard Time"
//        event.start = start
        event.start?.dateTime="2020-03-08T8:30:00"
        event.start?.timeZone="UTC"
//        let end = MSGraphDateTimeTimeZone()
//        end.dateTime = "2017-09-04T14:00:00"
//        end.timeZone = "Pacific Standard Time"
//        event.end = end
        event.end?.dateTime="2020-03-08T10:00:00"
        event.end?.timeZone="UTC"
//        let recurrence = MSGraphPatternedRecurrence()
        let pattern = MSGraphRecurrencePattern()
        pattern.type = MSGraphRecurrencePatternType.weekly()
        pattern.interval = 1
        var daysOfWeekList: [AnyHashable] = []
        daysOfWeekList.append("Wednesday")
        pattern.daysOfWeek = daysOfWeekList
//        recurrence.pattern = pattern
        let range = MSGraphRecurrenceRange()
        range.type = MSGraphRecurrenceRangeType.endDate()
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        range.startDate = MSDate(year: 2020, month: 03, day: 08)
//        MSDate(nsDate:dateFormatter.date(from: "2020-03-04"))
        range.endDate = MSDate(year: 2020, month: 04, day: 08)   //(nsDate:dateFormatter.date(from: "2020-04-04"))
//        recurrence.range = range
  
        event.recurrence?.pattern=pattern
        event.recurrence?.range=range
//        let location = MSGraphLocation()
//        location.displayName = "Harry's Bar"
//        event.location = location
//        var attendeesList: [AnyHashable] = []
//        let attendees = MSGraphAttendee()
//        let emailAddress = MSGraphEmailAddress()
//        emailAddress.address = "AdeleV@contoso.onmicrosoft.com"
//        emailAddress.name = "Adele Vance"
//        attendees.emailAddress = emailAddress
//        attendees.type = MSGraphAttendeeType.required()
//        attendeesList.append(attendees)
//        event.attendees = attendeesList

//        var error: Error?
//        let eventData = try event.getSerializedData()
//        urlRequest.httpBody = eventData
        do{
                  let eventData = try event.getSerializedData()
                  print(eventData)
                  urlRequest?.httpBody = eventData
              }
              catch {
                  print(error)
              }

       var meDataTask: MSURLSessionDataTask? = nil
        if let urlRequest = urlRequest {
                   meDataTask = httpClient?.dataTask(with: urlRequest, completionHandler: { data, response, nserror in
                       //Request Completed
                       print("event added")
                       
                   })
               }

        meDataTask?.execute()

    }
    //Mark:Google Calendar
    @IBAction func googleSignInBtnPressed(_ sender: UIButton) {
          GIDSignIn.sharedInstance().signIn()
      }
      // Create an event to the Google Calendar's user
        func addEventoToGoogleCalendar(summary : String, description :String, startTime : String, endTime : String) {
            let calendarEvent = GTLRCalendar_Event()
            
            calendarEvent.summary = "\(summary)"
            calendarEvent.descriptionProperty = "\(description)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let startDate = dateFormatter.date(from: startTime)
            let endDate = dateFormatter.date(from: endTime)
            
            guard let toBuildDateStart = startDate else {
                print("Error getting start date")
                return
            }
            guard let toBuildDateEnd = endDate else {
                print("Error getting end date")
                return
            }
            calendarEvent.start = buildDate(date: toBuildDateStart)
            calendarEvent.end = buildDate(date: toBuildDateEnd)
           
            let insertQuery = GTLRCalendarQuery_EventsInsert.query(withObject: calendarEvent, calendarId: "primary")
             calendarEvent.recurrence = ["RRULE:FREQ=DAILY;UNTIL=20200428"]
            service.executeQuery(insertQuery) { (ticket, object, error) in
                if error == nil {
                    print("Event inserted")
                } else {
                    print(error)
                }
            }
        }
        
        // Helper to build date
        func buildDate(date: Date) -> GTLRCalendar_EventDateTime {
            let timeZone = NSTimeZone.system
            let datetime = GTLRDateTime(date: date)
            let dateObject = GTLRCalendar_EventDateTime()
            dateObject.dateTime = datetime
            dateObject.timeZone=timeZone.identifier
            return dateObject
        }
        // Helper for showing an alert
        func showAlert(title : String, message: String) {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: UIAlertController.Style.alert
            )
            let ok = UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default,
                handler: nil
            )
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
 }
     //MARK:Google SignIn 
 extension MainViewController:GIDSignInDelegate{
     //MARK:Google SignIn Delegate
     func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
         // myActivityIndicator.stopAnimating()
     }
     // Present a view that prompts the user to sign in with Google
     func sign(_ signIn: GIDSignIn!,
               present viewController: UIViewController!) {
         self.present(viewController, animated: true, completion: nil)
     }
     
     // Dismiss the "Sign in with Google" view
     func sign(_ signIn: GIDSignIn!,
               dismiss viewController: UIViewController!) {
         self.dismiss(animated: true, completion: nil)
     }
     ////Google_signIn
     func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
               withError error: Error!) {
         if let error = error {
             showAlert(title: "Authentication Error", message: error.localizedDescription)
             self.service.authorizer = nil
         } else {
             self.service.authorizer = user.authentication.fetcherAuthorizer()
             addEventoToGoogleCalendar(summary: "test repetation", description: "description", startTime: "08/03/2020 15:00", endTime: "08/03/2020 17:00")
         }
     }
    //MARK:APPLE
    @IBAction func addEventToAppleBtnPressed(_ sender: UIButton) {
     print(Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let tillDate = dateFormatter.date(from: "08/4/2020 17:00")
        addEventoToAppleCalendar(title: "test Repetation", description: "we are here", eventStartDate: dateFormatter.date(from:"08/03/2020 15:00")!, eventEndDate: dateFormatter.date(from:"08/03/2020 17:00")!,tillDate:tillDate!)
         }
 }
 //Apple Calendare
 extension MainViewController{
    func addEventoToAppleCalendar(title: String, description: String?, eventStartDate: Date, eventEndDate: Date,tillDate:Date){
        let eventStore : EKEventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(String(describing: error))")
                
                var event:EKEvent = EKEvent(eventStore: eventStore)
//                for index in 1...5 {
                    event = EKEvent(eventStore: eventStore)
                    event.title = title
                    event.startDate = eventStartDate
                    event.endDate = eventEndDate
                    event.notes = description
                    event.calendar = eventStore.defaultCalendarForNewEvents
              
                let recurrenceRule = EKRecurrenceRule.init(
                                 recurrenceWith: .daily,
                                 interval: 1,
                                 daysOfTheWeek: [EKRecurrenceDayOfWeek.init(EKWeekday.saturday),EKRecurrenceDayOfWeek.init(EKWeekday.sunday),EKRecurrenceDayOfWeek.init(EKWeekday.monday),EKRecurrenceDayOfWeek.init(EKWeekday.tuesday),EKRecurrenceDayOfWeek.init(EKWeekday.wednesday),EKRecurrenceDayOfWeek.init(EKWeekday.thursday),EKRecurrenceDayOfWeek.init(EKWeekday.friday)],
                                 daysOfTheMonth: nil,
                                 monthsOfTheYear: nil,
                                 weeksOfTheYear: nil,
                                 daysOfTheYear: nil,
                                 setPositions: nil,
                                 end: EKRecurrenceEnd.init(end:tillDate)
                             )

                             event.recurrenceRules = [recurrenceRule]
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch let error as NSError {
                        print("failed to save event with error : \(error)")
                    }
                    print("Saved Event")
//                }
            }
            else{
                
                print("failed to save event with error : \(String(describing: error)) or access not granted")
            }
        }
    }
 }
