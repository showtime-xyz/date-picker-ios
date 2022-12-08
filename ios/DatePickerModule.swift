import ExpoModulesCore


struct DatePickerOptions: Record {
  @Field
  var minimumDate: Double = 0

  @Field
    var maximumDate: Double = 0
    
  @Field
    var value: Double = 0
    
  @Field
    var mode: String = "";
}


public class DatePickerModule: Module {
    var alertController: UIAlertController? = nil;
    var alertWindow: UIWindow? = nil;
    

  public func definition() -> ModuleDefinition {
      Name("DatePicker")
      
      AsyncFunction("dismiss") { (promise: Promise) in
          self.alertController?.dismiss(animated: true);
          self.alertController = nil;
          self.alertWindow = nil
          promise.resolve()
      }.runOnQueue(.main)
      
      AsyncFunction("open") { (options: DatePickerOptions, promise: Promise) in
          
          let datePicker = UIDatePicker()
          datePicker.datePickerMode = .dateAndTime
          
          if (options.value != 0) {
              datePicker.date =  Date(timeIntervalSince1970: options.value);
          }
          
          if (options.minimumDate != 0) {
              datePicker.minimumDate =  Date(timeIntervalSince1970: options.minimumDate);
          }

          if (options.maximumDate != 0) {
              datePicker.maximumDate =  Date(timeIntervalSince1970: options.maximumDate);
          }
        
          if (options.mode != "") {
              if (options.mode == "datetime") {
                  datePicker.datePickerMode = .dateAndTime
              } else if (options.mode == "date") {
                  datePicker.datePickerMode = .date
              } else if (options.mode == "time") {
                  datePicker.datePickerMode = .time
              }
          }

            
            if #available(iOS 14, *) {
                datePicker.preferredDatePickerStyle = .inline
            } else if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }

          
          let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
          self.alertController = alert;
          
          alert.view.addSubview(datePicker)

          
          // make height equal to date picker and adjust for Ok and Cancel buttons
          let heightConstraint = NSLayoutConstraint(item: alert.view as Any, attribute: .height, relatedBy: .equal, toItem: datePicker, attribute: .height, multiplier: 1, constant:  2 * 80)
          alert.view.addConstraint(heightConstraint)

          // Adds some padding top to date picker
          datePicker.bounds = datePicker.frame.insetBy(dx: 0.0, dy: -32.0);


          
          // Horizontally center date picker
          datePicker.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
          ])
        

          // Add an action to the alert controller that will trigger when the user selects a date
          let okAction = UIAlertAction(title: "OK", style: .default) { _ in
              let selectedDate = datePicker.date
              promise.resolve(selectedDate.timeIntervalSince1970 * 1000);
              self.alertController = nil;
              self.alertWindow = nil
          }
            alert.view.frame = datePicker.frame;

          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
                promise.reject(Exception(name: "dismissed", description: "User dismissed the picker"));
              self.alertController = nil;
              self.alertWindow = nil
            })

          // Add the action to the alert controller
          alert.addAction(okAction)
          alert.addAction(cancelAction)

         

          let alertWindow = UIWindow(frame: UIScreen.main.bounds)
          alertWindow.rootViewController = UIViewController()
          alertWindow.windowLevel = UIWindow.Level.alert + 1;
          alertWindow.makeKeyAndVisible()
          alertWindow.rootViewController?.present(alert, animated: true)
          
          self.alertWindow = alertWindow;

      }.runOnQueue(.main)
  }
}
