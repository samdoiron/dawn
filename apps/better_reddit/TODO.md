Todo
====

## Reddit Gatherer
The thing that actuall gets the content of reddit, and stores it for the
rest of the App to use.

### Done
- Parser

### Left
- Persistance
- Reddit API module / behaviour
- Gathering worker

### API Module

This will probably be very simple, and just contain all the knowledge
about the specific URLs that are used. Ideally this would work independantly
from requiring an ACTUAL HTTP connection to reddit's API. The WIP `Fetch`
behaviour is probably the correct solution.

But I don't like having it as a module... because doesn't that make it not
safe to have across tests? Probably not a huge deal, actually... Yeah, just
make them not async. Sure.

Actually, thinking again, the Mock blog post suggested just testing directly
against the *actual api*, which might make more sense. I mean, otherwise
I'm just repeating the URL's multiple times... but how would I do that?
Just make sure that the thing returned can be parsed as a listing?
Sounds reasonable, actually.

Hmm... But how do I handle ratelimiting? Should the API itself do that?
It seems like it might want to... otherwise, you could accidentally not
do it, which would be bad.

BUT, ultimately I might want to separate that, because I will have different
rate limiting behaviour if I distributed the requests across multiple IPs.


So next steps:
- Remove the "Fetch" behaviour
- Implement the Reddit API + tests with ***live actual reddit***.

### Worker

This should work in a single loop, just fetching from the front-page
to start with.

So what is the testing story for this component? 

### Persistance
Does this need to use a database yet? Is there a reason not to? I guess it would
make it a bit more annyoing during development, because you have to maintain
migrations etc, and start up a database before developing.

Really, this could just be an in-memory thing for now. Super fast, too!



## Website

### Left
- Pull content from storage
- Make attractive tempalte (HTML+CSS) to display content.