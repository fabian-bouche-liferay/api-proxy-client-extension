# API Proxy Client Extension

Sometimes, the Liferay project and frontend client extensions have to integrate
with existing APIs.

In those situations, it is frequent to have to deal with CORS and backend service
authentication.

The objective of this client extension is to make it easy to turn those existing
APIs into assets you can easily query from Liferay frontend client extensions
to make them first class citizens, leveraging the Liferay user authentication
as well as the authorizations using custom OAuth 2.0 scopes you can manage
in Liferay.

## Setting up

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

## Defining routes

Check the apisix.yaml file to define routes.

If you need to authenticate against backend APIs, I'd suggest you negotiate
tokens in a startup script (look at my get_dxp_pem.py as an inspiration) and
make them available as environment variables which you can use in
https://apisix.apache.org/docs/apisix/plugins/proxy-rewrite/ plugins to add
them as Authorization headers for example.
