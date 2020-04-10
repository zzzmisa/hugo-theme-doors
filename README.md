# Hugo Theme Doors
Single page theme for links to your works.  
See a real usage here: https://zzzmisa.com/

## PC view
![Doors screenshot](https://github.com/zzzmisa/hugo-theme-doors/blob/master/images/screenshot.png?raw=true)

## Mobile view
<img src="https://github.com/zzzmisa/hugo-theme-doors/blob/master/images/screenshot_mb.png?raw=true" height="600">

## Features
* Links to your works
* Responsive
* SNS button
* Google Analytics
* Accelerated Mobile Pages (AMP) supported

## Getting started
The example of how to use this theme is provided in the `exampleSite` folder. At first, try running the example site. The contents of the site can be configured by `config.toml`. After the example site appears, rewrite `config.toml` with your own data to make your own site.

## Run example site
1. Install [Hugo](https://gohugo.io/).
2. Create a new project folder to running the example site.
    ```
    $ mkdir mySite
    ```
3. Install this theme into your project folder.
    ```
    $ cd mySite
    $ git clone https://github.com/zzzmisa/hugo-theme-doors.git themes/hugo-theme-doors
    ```
4. Copy the entire contents of the `exampleSite` to root folder of your project folder.
    ```
    $ cp -r themes/hugo-theme-doors/exampleSite/* .
    ```
5. Test the example site. 
    ```
    $ hugo server -w
    ```
    See the result at http://localhost:1313/ on your browser.
6. Build the example site. 
    ```
    $ hugo
    ```
    Find result files in the `public` folder in the root of your project folder.
    
## Contributing
Bug reports and pull requests are welcome! By submitting a pull request, you agree to license your contribution under the MIT license.

## Supported Hugo versions
Hugo Theme Doors is tested against Hugo `v0.53` to `v0.68.3`.
