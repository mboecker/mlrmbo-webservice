# Documentation of the API

The API is designed to work with "sessions".
That is, the user/client creates a session, which is a handle to the uploaded data on the server-side.
The session id is randomly generated on session creation.
It has to be supplied with every API call so that the server can match the request to the uploaded data.

## Workflow

- Open a session
- Update configuration
- Upload your data
- Request a proposal
- Upload more data
- Request more proposals ...
- Close your session

### Open a session

`GET /session/open`

This API endpoint creates a new empty session.

- Returns your new Session ID

### Update Configuration

`GET /set/<session_id>/<key>/<value>`

You can set mlrMBO-options using this endpoint. Possible keys are for example:

#### Boolean
- noisy (boolean): Is the optimized function deterministic or stochastic?
- minimize (boolean): Is the optimum a minimal or maximal value?
- propose.points (numeric): How many points should be proposed?

#### Numeric
- opt.restarts (numeric): How often should the infill-optimizer be run?
- opt.focussearch.maxit (numeric): If `opt = "focussearch"`: How many iterations should be used.
- opt.focussearch.points (numeric): If `opt = "focussearch"`: How many points should be used.

#### Other
- learner: What stochastic model should be used to model your data?
- crit: Use "Expected Improvement" or "Confidence Bound" as the infill criterium?
- opt: How to find an interesting point (focussearch, cmaes or nsga2)

The supplied value has to be accepted by the key, e.g. you can't set `minimize` to 5 (`minimize` is a boolean key).
If you don't alter the configuration using this API-endpoint, our service will use the default mlrMBO configuration.

- Returns ok or an error, if you tried to set invalid data

### Upload data

`GET /upload/<session_id>/<data as json>`

Using this API endpoint you can upload new data to your session.
You can't delete server-side data, but only append to the already uploaded data.

- Returns "ok" or an error, if your data is malformed

### Request a proposal

`GET /propose/<session_id>`

When there is uploaded data, the server attempts to propose an interesting point for your supplied data.
If you misconfigured your session or the data is malformed, this call will fail and return an error instead.

- Returns the X values for the proposed point or an error

### Close the session

`GET /session/close/<session_id>`

If you don't need your session anymore, you can close it with this API endpoint.
This will delete your data from the server.

- Returns "ok" if there was such a session
