var http = require('http');

var httpProxy = require('http-proxy');

JENKINS_URL = process.env.JENKINS_URL;
JENKINS_AUTH = process.env.JENKINS_AUTH;

var proxy = httpProxy.createProxyServer({
    target: {
        host: 'localhost',
        port: '8000',
    },
    ws: true,
});

var proxyServer = http.createServer(function (req, res) {
    var jenkinsUrl = req.url.match(/^\/external\/jenkins(.*)/)
    if (jenkinsUrl !== null) {
        path = jenkinsUrl[1];
        req.url = path;
        proxy.web(req, res, {
            target: JENKINS_URL,
            auth: JENKINS_AUTH,
        });
    } else {
        proxy.web(req, res, {
            target: 'http://localhost:8000',
        });
    }
});

proxyServer.on('upgrade', function (req, socket, head) {
    console.log('upgrade', req.url);
    proxy.ws(req, socket, head);
});

proxyServer.listen(9000);
