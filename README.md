
# phone_number_validation

A Flutter project.

## Getting Started

This project aims to search the country code and verify the input phone number.

### Preparation for flutter in Vscode
- Install Flutter extension;
- Press `Ctrl+Shift+P` and enter `Flutter: New Project`;
- Choose `File > Open Folder`, open the new project;



### Install proxy server to avoid CORS
**Before going through this step, you need to install node.js in your device. Make sure `node` command is in your environment variables**
- Install http-proxy-middleware

Enter `npm install http-proxy-middleware` in the terminal;

The `proxy.js` file is already in the root directory.

- Configuration
  
No need to go through this step, already done in `package.json`;

- Run the proxy server

Run `node proxy.js` in the terminal;

### Register for Twilio and get your accountSid and authToken
After register for twilio, create a service.
Fill in the null char in validation_bloc.dart file:

`final accountSid = ''; // Twilio Account SID`

`final authToken = ''; // Twilio Auth Token`

### Run result
![Pict](./showPict/1.png "1")
![Pict](./showPict/2.png "1")
![Pict](./showPict/3.png "1")
![Pict](./showPict/4.png "1")

