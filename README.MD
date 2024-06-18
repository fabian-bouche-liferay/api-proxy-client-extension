# API Proxy Client Extension

This client extension helps register a backend API so as to make it available:
 - As a CORS enabled API
 - Or as an OAuth 2.0 Resource Server trusting Access Tokens issued by the Liferay
OAuth 2.0 Authorization Server

OAuth 2.0 Resource Servers can define their own OAuth 2.0 scopes.
But at this point, you will have to define them as Service Access Policy entries
in the Liferay Control panel.

`OAUTH2_httpbin.read` Service Access Policy entry will translate as
`liferay-json-web-services.httpbin.read` OAuth 2.0 scope.

When configured as an OAuth 2.0 Resource server, you will be able to call the
API this way from your frontend Javascript application:

```
Liferay.OAuth2Client.FromUserAgentApplication(
        'httpbin-apisix-user-agent'
    ).fetch(
        'https://apisixhttpbin-extb5r4cxemea1-extprd.lfr.cloud/with-oauth'
    ).then(
        data => console.log(data)
    );
```

Where `apisixhttpbin-extb5r4cxemea1-extprd.lfr.cloud` is the hostname of the
service proxy (you can customize the domain in the cloud console configuration).