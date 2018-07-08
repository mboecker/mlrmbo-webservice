# Workflow

- Open a session
- Upload your data
- Request a proposal
- Upload more data
- Request more proposals ...
- Close your session

# Open a session

`GET /session/open`

- Returns your Session ID

# Upload data

`GET /upload/<session_id>/<data as json>`

- Returns "ok" or an error

# Request a proposal

`GET /propose/<session_id>`

- Returns the X values for the proposed point

# Close the session

`GET /session/close/<session_id>`

- Returns "ok" if there was such a session
