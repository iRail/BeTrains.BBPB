# BeTrains for the Blackberry Playbook

iRail is an attempt to make transportation time schedules easily available for anyone. BeTrains takes its content from the iRail API.

All information can be found on [Project iRail](http://project.irail.be/).

Some interesting links:

  * Source: <http://github.com/iRail/iRail>
  * Mailing: <http://list.irail.be/>
  * Trac: <http://project.irail.be/>
  * API: <http://api.irail.be/>
  * BeTrains: <http://betrains.com/>


# Set up
 - Pull the project from Github
 - Create new a new project in Flash Builder in the folder where you pulled the project in
 - Choose the Blackberry SDK in  the project's properties
 - add the resources folder to your source path
 - run ant-file build.xml

# Testing
To test the app, follow these steps (first time only):
 - start simulator/device and enable development mode
 - Select the main mxml
 - Goto the Project menu, choose Debug configurations
 - Select Blackberry Tablet OS Application (double click)
 - Under Deployment, enter target (Playbook) IP (default 192.168.132.38 for simulator)
 - under Debug Host (your development computer) (default 192.168.132.1 for simulator) 
 - Enter the device pwd
 - click debug
