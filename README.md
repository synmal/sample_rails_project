# Sample Rails project

### Ruby version
* 2.6.6

### System dependencies
* Rails 6.0.3

### Login to get access token
`
curl -X POST -d "grant_type=password&email=user@example.com&password=yourpassword" localhost:3000/oauth/token
`

### Using your endpoints
`
curl -v localhost:3000/users?access_token=OurAccessTokenReturnedByAPI
`
