---
layout: post
title: "REST API Changelog"
date: "2017-11-17"
sidebar: api_sidebar
permalink: docs-api-changelog.html
categories: changelog
---


## [1.7.1] - 2017-11-17

### Added

#### Add ability to provide email address for email copies through curly brace templating

`Parameters.insertPhoneNumberHere.email` is now used to fill a recipeints email in order to be able to send email copies without the use of contacts. If you want to use the `email` argument without email copies you can set the root property `Email` to `false`.

### Fixed

#### Made SMS and email copies send the same text when using curly brace templating on the `sms/send` endpoint

Previously SMS and email copies were templated seperatly which made it so that when we implemented the curly bracket based templating, email copies was not affected making the SMS text and the email text differ if curly brace templating was used.

``` plain
Hi my name is {name} how are you today {title} {lastName}?
```

The text above would result in no change for the email copies while the SMS would look someting along the lines of this:

``` plain
Hi my name is Earl how are you today Sir Newton?
```