# HelloWorld Express App

This folder contains a minimal Express app in `app.js` that serves a single route.

## What the app does
- Creates an Express application instance.
- Registers a GET handler for `/` that responds with `Hello World!`.
- Starts an HTTP server listening on port `3000` and logs a message when ready.

## How to run it
1. Open a terminal and go to this folder:

```bash
cd /home/htritai/Downloads/IT-Course/HoiDanIt/NodeJs-Pro/Section3-17-MVC-REST_APIs-SQL-MongoDB/Section3-HelloWorld
```

2. Install dependencies (this project does not include a `package.json`, so initialize one first):

```bash
npm init -y
npm install express
```

3. Start the server:

```bash
node app.js
```

4. In your browser, visit:

```
http://localhost:3000/
```

You should see `Hello World!`.

## What you should see in the terminal
When the server starts, it logs:

```
Example app listening on port 3000
```

## How the request flow works
1. `require('express')` loads the Express framework.
2. `const app = express()` creates the application object.
3. `app.get('/', (req, res) => { ... })` registers a route handler for HTTP GET requests to `/`.
4. When a request arrives at `/`, Express invokes the handler, which sends a response body with `res.send('Hello World!')`.
5. `app.listen(3000, ...)` starts the HTTP server. The callback runs once the server is ready, logging the message.
