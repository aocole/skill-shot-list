skill-shot-list
===============

The Rails app that runs the list.skill-shot.com site

## Models
There are 3 levels of hierarchy to geographic information in the app: Area, Locality, and Location.
 * Area is the top-level of the hierarchy. The Areas used on the main Skill Shot web site are Seattle, King County, Road Trip, Snohomish County, and Kitsap County.
 * Locality represents a smaller region within an Area. Within the Seattle Area, the Localities correspond to neighborhoods. In other Areas, the Localities correspond to cities.
 * Location represents a specific business or other establishment that contains pinball machines.

Pinball games are modeled using Title and  Machine.
 * Title represents the concept of a particular pinball game design, such as Medieval Madness or Terminator 2.
 * Machine is a specific instance of a Title. For example, a Machine record could represent a specific Medieval Madness game at a Location.

## JSON API
All requests must set the headers `Content-Type: application/json` and `Accept: application/json`

### Locations
`GET /locations.json`
`GET /locations/{location_id}.json`
`GET /locations/{location_id}/machines.json`

### Machines
`GET /machines/{machine_id}.json`

### Titles
`GET /titles.json` -- Every pinball title ever made
`GET /titles/active.json` -- Every pinball title for which a Machine exists in the database.

### Localities
`GET /areas/{area_id}/localities.json`

### Login
On successful login, sets a `user_credentials` cookie which can be used to authenticate later requests requiring authentication.
`POST /user_session`
Request Payload:
```json
{
    "user_session": {
        "email": "admin@example.com",
        "password": "mypassword"
    }
}
```
Response Payload:
```json
{"success": [bool]}
```


