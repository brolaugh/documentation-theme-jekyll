---
layout: post
title: "Sending SMS through the REST API"
sidebar: api_sidebar
categories: documentation
permalink: docs-api-sending+sms.html
tags: [documentation]
---

Sending SMS messages
-----------

* Base URL: `https://api.ip1sms.com/`
* Endpoint: `api/sms/send`

In order to send SMS messages you need to have credits. When you create an account and verify your phone number you'll be given €1 in credits, the amount of SMS messages you'll be able to send with those credits will heavily depend on what country you'll be sending the messages to.

When creating a request to send SMS messages we use the `/api/sms/send` endpoint with the HTTP method `POST`.

Since our REST API is JSON based that's the data structure we'll use and when sending SMS messages we have seven properties to play with:

* `From`: Who or what the SMS message should be sent from can be either a up to 15 digit (telephone) number or an up to 11 character ASCII string.
* `Numbers`: A `collection` of phone numbers with country code, eg. 46 for Sweden.
* `Contacts`: A `collection` of contact IDs. See the Contact section for how to use these.
* `Groups`: A `collection` of group IDs. See the Group section for how to use these.
* `Message`: A `string` containing the message you want to send to the recipients above.
* `Prio`: DEPRECATED! This value was previously used for sending SMS with higher priority. Now all SMS are sent with with the same prio independently of what Prio value is used.
* `Email`: A `boolean` value of whether email copies should be sent or not to the recipients that has an email provided previously. Note that in order for email copies to be sent you need to purchase the service `Email Copy`.

All recipients (Numbers, Contacts, Groups) will be converted into a single collection of Contacts (So that emails addresses and templating fields are conserved where applicable) and then remove all duplicated contacts distincted by their phone number.

``` json
{
  "Numbers": [
    "+14155552671",
    "+14155552672"
  ],
  "Contacts": [
    2314,
    2412
  ],
  "Groups": [
    989,
    898
  ],
  "Email": false,
  "Prio": 1,
  "From": "iP.1",
  "Message": "This is the day you will always remember as the day you almost caught Captain Jack Sparrow!"
}
```

### Templating

Templating can be done by wrapping an argument with curly brackets (`{lastName}`) and then adding an object to the `Parameters` array with the phone number as the property name. For phone numbers not provided you may also specify templating values in the `Parameters` property `default`. The arguments specified in the message text will be replaced with their respective values prioritized in the following order:

1. Number specific value eg. `"4610606060": {"title": "Sir"}`
2. Default value
3. Empty string

Note that if a you specify an argument in the message but don't provide an example for it in the parameter data it will not be replaced. As you can see below the whole message is wrapped in curly brackets. However if a parameter is given to only one recipient and not the others (including default) the parameter will default to empty string. This enables us to still use curly brackets outside of templating.

``` json
{
  "From": "TestNOS",
  "Numbers": [
    "4610606060",
    "46769447696"
  ],
  "Message": "{: Hello {title} {lastName}, how are you doing this fine day? :}",
  "Parameters": {
    "4610606060": {
      "title": "Sir",
      "lastName": "Newton"
    },
    "default": {
      "lastName": "Friend"
    }
  }
}
```

### Code Examples

Below you'll see example code for sending an SMS in a few languages.

#### .NET / C#

``` csharp
string account = "ip1-xxxxx";
string password = "cCnbXFfyTM5BTKh7uNV"

using (var client = new HttpClient())
{
    client.BaseAddress = new Uri("https://api.ip1sms.com/api/");
    client.DefaultRequestHeaders.Accept.Clear();
    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

    string authString = Convert.ToBase64String(Encoding.ASCII.GetBytes($"{account}:{password}");
    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", authString);

    var sms = new object()
    {
        From = "iP1",
        Numbers = new List<string>() { "46123456789" },
        Contacts = new List<int>(),
        Groups = new List<int>(),
        Message = "This is the day you will always remember as the day you almost caught Captain Jack Sparrow!",
        Email = false
    };

    HttpResponseMessage response = await client.PostAsJsonAsync("sms/send", sms);
}
```

#### PHP

``` php
// Account information and where we will send the request to
$conf = array(
  'account' => 'ip1-xxxxx',
  'password' => 'cCnbXFfyTM5BTKh7uNV',
  'apiUrl' => 'api.ip1sms.com',
  'method' => 'POST',
  'endpoint' => '/api/sms/send',
);
// The message it self
$message = array(
  'Numbers' => ['4673055555'],
  'From' => 'iP.1',
  'Message' => "This is the day you will always remember as the day you almost caught Captain Jack Sparrow!",
);
// Encode to JSON
$jsonEncodedMessage = json_encode($message);
// Set up request options
$options = array(
    'http' => array(
        'header'  => array(
            'Content-Type: application/json',
            'Authorization: Basic '. base64_encode($conf['account'].":".$conf['password']),
            'Content-Length: ' . strlen($jsonEncodedMessage)
        ),
        'method'  => $conf['method'],
        'content' => $jsonEncodedMessage,
    )
);
// Construct the URL
$url = "https://" . $conf['apiUrl'] . $conf['endpoint'];
$context  = stream_context_create($options);
// Send the request
$response = file_get_contents($url, false, $context);
```

Reading sent SMS messages
----------------

* Base URL: `https://api.ip1sms.com/`
* Endpoint: `api/sms/sent/{id}`

Once you've sent your request to `api/sms/send` you will first get a response for the SMS message containing information such as ID, message, recipient phone number and initial status report like the json below.

``` json
{
  "ID": 7331,
  "BundleID": 1337,
  "To": "4610606060",
  "From": "iP1",
  "Message": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
  "Status": 0,
  "StatusDescription": "Delivered to gateway",
  "Created": "2017-11-15T10:31:11.1727413+00:00",
  "Modified": "2017-11-15T10:31:11.1727413+00:00"
}
```

* `ID`: A unique integer value for the specific SMS message.
* `BundleID`: Multiple messages may be sent in one request, if that is the case a bundle ID will be added in order to group the messages together. If the message was sent alone no BundleID will be given to the message.
* `Status`: Integer value telling the status of the SMS message. See [Status codes](#status-codes) for possible values.
* `StatusDescription`: A describing text of the status code.
* `Created`: When the SMS message was created in UTC.
* `Modified`: When the SMS message was last updated. Most often when the status was updated. Only available on `GET` requests.

You can later use the ID to fetch updates for the specific SMS messages via the `api/sms/sent/{id}`-endpoint but you can also fetch all your sent SMS messages by not providing an ID and making a request to `api/sms/sent`.

Status codes
------------

This is the list of all our SMS message status codes and their description.

Status code| Description
-----------|------------
0          | Delivered to gateway
1          | Gateway login failed
2          | Invalid message content
3          | Invalid phone number format
4          | Insufficient funds
10         | Received by the gateway
11         | Delayed delivery
12         | Delayed delivery cancelled
21         | Delivered to the GSM network
22         | Delivered to the phone
30         | Insufficient funds
41         | Invalid message content
42         | Internal error
43         | Delivery failed
44         | Delivery failed
45         | Invalid phone number
50         | General delivery error
51         | Delivery to GSM network failed
52         | Delivery to phone failed
100        | Insufficient credits
101        | Wrong account credentials
110        | Parameter error