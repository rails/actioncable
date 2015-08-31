## Working with npm

* `npm install` - will install all devtools to local node_modules/ directory
* `npm run build` - will build CommonJS compatible module in dist/index.js
* `npm run test` - will run tests for CommonJS module
* `npm run test-sprockets` - will run tests for sprockets packaged module (using PhantomJS)
* `npm run pack` - will create npm package with pre-compiled and ready-to-use in CommonJS bundlers(browserify, webpack) actioncable client

## Known issues
`npm install` will download pre-compiled phantomjs binaries, but if you use ubuntu, you should additionally install some font pckages `apt-get install libfreetype6-dev libfontconfig1-dev`
